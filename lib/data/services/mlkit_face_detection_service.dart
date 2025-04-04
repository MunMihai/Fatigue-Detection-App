import 'package:camera/camera.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/core/utils/face_detector_painter.dart';
import 'package:driver_monitoring/core/utils/salt_and_papper_filter.dart';
import 'package:driver_monitoring/domain/services/face_detection_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class MLKitFaceDetectionService implements FaceDetectionService {
  static const int _minProcessDelayMs = 100;

  static const double _eyeOpenTreshold = 0.4;
  static const double _eyeProbabilityDifferenceThreshold = 0.3;
  static const double _yawnOpenThreshold = 0.4;
  static const double _noseDistanceThreshold = 1.2;
  static const double _yawToleranceRatio = 0.4;

  final int _windowSize = 3;
  final double _saltPepperThreshold = 0.3;

  final CameraLensDirection _cameraLensDirection = CameraLensDirection.front;
  final FaceDetector _faceDetector;

  final List<double> _leftEyeProbabilities = [];
  final List<double> _rightEyeProbabilities = [];

  bool _isProcessing = false;

  CustomPaint? _customPaint;
  String? _detectionText;

  int closedEyesFrameCounter = 0;
  int yawnFrameCounter = 0;

  late int _closedEyesFrameThreshold;
  late int _yawnFrameThreshold;

  DateTime _lastFaceDetectedTime = DateTime.now();
  DateTime? _lastProcessTime;

  MLKitFaceDetectionService(FaceDetectorMode mode)
      : _faceDetector = FaceDetector(
          options: FaceDetectorOptions(
            enableContours: true,
            enableLandmarks: true,
            performanceMode: mode,
            enableClassification: true,
          ),
        );

  @override
  bool get closedEyesDetected =>
      closedEyesFrameCounter >= _closedEyesFrameThreshold;
  @override
  bool get yawningDetected => yawnFrameCounter >= _yawnFrameThreshold;
  @override
  DateTime get lastFaceDetectedTime => _lastFaceDetectedTime;
  @override
  CustomPaint? get customPaint => _customPaint;
  @override
  String? get detectionText => _detectionText;

  @override
  void reset(int sensitivity) {
    appLogger.i('[FaceDetectionService] Resetting...');
    closedEyesFrameCounter = 0;
    yawnFrameCounter = 0;

    _customPaint = null;
    _detectionText = '';

    _closedEyesFrameThreshold = (11 - sensitivity);
    _yawnFrameThreshold = (7 - sensitivity).clamp(3, 7);

    _lastFaceDetectedTime = DateTime.now();
  }

  @override
  Future<void> processImage(InputImage inputImage) async {
    if (_isProcessing) {
      return;
    }

    final currentTime = DateTime.now();
    if (_lastProcessTime != null &&
        currentTime.difference(_lastProcessTime!).inMilliseconds <
            _minProcessDelayMs) {
      return;
    }
    _lastProcessTime = currentTime;
    _isProcessing = true;

    _detectionText = '';

    final faces = await _faceDetector.processImage(inputImage);

    if (faces.isEmpty) {
      _handleNoFaceDetected();
      return;
    }

    _lastFaceDetectedTime = DateTime.now();

    final face = _selectPrimaryFace(faces);

    final yawnStatusText = _processYawning(face);

    String eyeStatusText = '';
    if (yawnFrameCounter <= 0) {
      eyeStatusText = _processEyeState(face);
    } else {
      closedEyesFrameCounter = 0;
    }

    _detectionText = 'Face found\n\n$eyeStatusText\n$yawnStatusText';

    _updatePainter(inputImage, face);

    _isProcessing = false;
  }

  void _handleNoFaceDetected() {
    _detectionText = 'No face detected';
    _customPaint = null;
    _isProcessing = false;
  }

  Face _selectPrimaryFace(List<Face> faces) {
    faces.sort((a, b) => b.boundingBox.height.compareTo(a.boundingBox.height));
    return faces.first;
  }

  String _processEyeState(Face face) {
    final leftEyeOpenProb = face.leftEyeOpenProbability;
    final rightEyeOpenProb = face.rightEyeOpenProbability;

    if (leftEyeOpenProb != null && rightEyeOpenProb != null) {
      _addToWindow(_leftEyeProbabilities, leftEyeOpenProb);
      _addToWindow(_rightEyeProbabilities, rightEyeOpenProb);

      final filteredLeft = SaltAndPaperFilter.applyFilter(_leftEyeProbabilities, _saltPepperThreshold);
      final filteredRight = SaltAndPaperFilter.applyFilter(_rightEyeProbabilities, _saltPepperThreshold);

      final avgLeftEyeOpenProb = _average(filteredLeft);
      final avgRightEyeOpenProb = _average(filteredRight);

      final difference = (avgLeftEyeOpenProb - avgRightEyeOpenProb).abs();

      final bothEyesClosed = avgLeftEyeOpenProb < _eyeOpenTreshold &&
          avgRightEyeOpenProb < _eyeOpenTreshold &&
          difference <= _eyeProbabilityDifferenceThreshold;

      if (bothEyesClosed) {
        closedEyesFrameCounter++;
        final text = '⚠️ Both eyes closed! Frame: $closedEyesFrameCounter';
        appLogger.w(text);
        return text;
      } else {
        closedEyesFrameCounter = 0;
        final text =
            '👁️ Eyes open\n - Left(filtered): ${avgLeftEyeOpenProb.toStringAsFixed(2)}'
            '\n - Right(filtered): ${avgRightEyeOpenProb.toStringAsFixed(2)}';
        appLogger.i(text);
        return text;
      }
    }

    closedEyesFrameCounter++;
    final fallbackText = '🔍 Eye probabilities unavailable.';
    appLogger.w(fallbackText);
    return fallbackText;
  }

  String _processYawning(Face face) {
    final landmarks = face.landmarks;

    final bottomMouth = landmarks[FaceLandmarkType.bottomMouth]?.position;
    final leftMouth = landmarks[FaceLandmarkType.rightMouth]?.position;
    final rightMouth = landmarks[FaceLandmarkType.leftMouth]?.position;
    final noseBase = landmarks[FaceLandmarkType.noseBase]?.position;
    final leftCheek = landmarks[FaceLandmarkType.leftCheek]?.position;
    final rightCheek = landmarks[FaceLandmarkType.rightCheek]?.position;

    if (_areLandmarksValid([
      bottomMouth,
      leftMouth,
      rightMouth,
      noseBase,
      leftCheek,
      rightCheek
    ])) {
      final mouthWidth = (leftMouth!.x - rightMouth!.x).abs();
      final mouthHeight =
          (bottomMouth!.y - ((leftMouth.y + rightMouth.y) / 2)).abs();
      final noseToMouthDistance = (bottomMouth.y - noseBase!.y).abs();

      final mouthOpenRatio = mouthHeight / mouthWidth;
      final noseMouthRatio = noseToMouthDistance / mouthWidth;

      final isYawning = (mouthOpenRatio > _yawnOpenThreshold) &&
          (noseMouthRatio > _noseDistanceThreshold);

      final cheeksDistance = (leftCheek!.x - rightCheek!.x).abs();
      final faceCenterX = (leftCheek.x + rightCheek.x) / 2;
      final noseOffset = (noseBase.x - faceCenterX).abs();
      final isHeadFacingForward =
          noseOffset < (_yawToleranceRatio * cheeksDistance);

      if (!isHeadFacingForward) {
        final warning = '🚫 Head is turned – skipping yawning detection';
        appLogger.i(warning);
        return warning;
      }

      if (isYawning) {
        yawnFrameCounter++;
      } else {
        yawnFrameCounter = 0;
      }

      final status = isYawning
          ? '😮 Yawning detected! MouthRatio: ${mouthOpenRatio.toStringAsFixed(2)}'
              ' | NoseRatio: ${noseMouthRatio.toStringAsFixed(2)}'
          : '🙂 No yawning. MouthRatio: ${mouthOpenRatio.toStringAsFixed(2)}'
              ' | NoseRatio: ${noseMouthRatio.toStringAsFixed(2)}';

      isYawning ? appLogger.w(status) : appLogger.i(status);
      return status;
    }

    final error = '❗ Required landmarks not found (nose/mouth)';
    appLogger.w(error);
    return error;
  }

  void _addToWindow(List<double> list, double value) {
    list.add(value);
    if (list.length > _windowSize) {
      list.removeAt(0);
    }
  }

  double _average(List<double> list) {
    if (list.isEmpty) return 0.0;
    return list.reduce((a, b) => a + b) / list.length;
  }

  bool _areLandmarksValid(List<dynamic> landmarks) {
    return landmarks.every((element) => element != null);
  }

  void _updatePainter(InputImage inputImage, Face face) {
    final metadata = inputImage.metadata;
    if (metadata?.size != null && metadata?.rotation != null) {
      final painter = FaceDetectorPainter(
        [face],
        metadata!.size,
        metadata.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      _customPaint = null;
    }
  }
}
