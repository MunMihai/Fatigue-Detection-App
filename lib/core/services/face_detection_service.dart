import 'package:camera/camera.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/core/utils/face_detector_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectionService extends ChangeNotifier {
  static const int _minProcessDelayMs = 300;
  static const double _yawnOpenThreshold = 0.4;
  static const double _noseDistanceThreshold = 1.2;
  static const double _eyeOpenTreshold = 0.4;
  static const double _eyeProbabilityDifferenceThreshold = 0.2;

  final List<double> _leftEyeProbabilities = [];
  final List<double> _rightEyeProbabilities = [];

  final int _windowSize = 3;
  final double _saltPepperThreshold = 0.3; 

  final CameraLensDirection _cameraLensDirection = CameraLensDirection.front;
  final FaceDetector _faceDetector;

  bool _canProcess = true;
  bool _isProcessing = false;

  CustomPaint? _customPaint;
  String? _detectionText;

  int closedEyesFrameCounter = 0;
  int yawnFrameCounter = 0;

  late int _closedEyesFrameThreshold;
  late int _yawnFrameThreshold;

  DateTime _lastFaceDetectedTime = DateTime.now();
  DateTime? _lastProcessTime;

  FaceDetectionService()
      : _faceDetector = FaceDetector(
          options: FaceDetectorOptions(
            enableContours: true,
            enableLandmarks: true,
            performanceMode: FaceDetectorMode.fast,
            enableClassification: true,
          ),
        );

  bool get closedEyesDetected =>
      closedEyesFrameCounter >= _closedEyesFrameThreshold;
  bool get yawningDetected => yawnFrameCounter >= _yawnFrameThreshold;

  DateTime get lastFaceDetectedTime => _lastFaceDetectedTime;
  CustomPaint? get customPaint => _customPaint;
  String? get detectionText => _detectionText;

  void reset(int sensitivity) {
    appLogger.i('[FaceDetectionService] Resetting...');
    closedEyesFrameCounter = 0;
    yawnFrameCounter = 0;

    _customPaint = null;
    _detectionText = '';

    _closedEyesFrameThreshold = (11 - sensitivity);
    _yawnFrameThreshold = (7 - sensitivity).clamp(2, 7);

    _lastFaceDetectedTime = DateTime.now();
    notifyListeners();
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess || _isProcessing) return;

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
    if (!yawningDetected) {
      eyeStatusText = _processEyeState(face);
    } else {
      closedEyesFrameCounter = 0;
    }

    _detectionText = 'Face found\n\n$eyeStatusText\n$yawnStatusText';

    _updatePainter(inputImage, face);

    _isProcessing = false;
    notifyListeners();
  }

  void _handleNoFaceDetected() {
    _detectionText = 'No face detected';
    _customPaint = null;
    _isProcessing = false;
    notifyListeners();
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

      final filteredLeft = _applySaltPepperFilter(_leftEyeProbabilities);
      final filteredRight = _applySaltPepperFilter(_rightEyeProbabilities);

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

    if (_areLandmarksValid([bottomMouth, leftMouth, rightMouth, noseBase])) {
      final mouthWidth = (leftMouth!.x - rightMouth!.x).abs();
      final mouthHeight =
          (bottomMouth!.y - ((leftMouth.y + rightMouth.y) / 2)).abs();
      final noseToMouthDistance = (bottomMouth.y - noseBase!.y).abs();

      final mouthOpenRatio = mouthHeight / mouthWidth;
      final noseMouthRatio = noseToMouthDistance / mouthWidth;

      final isYawning = (mouthOpenRatio > _yawnOpenThreshold) &&
          (noseMouthRatio > _noseDistanceThreshold);

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

  List<double> _applySaltPepperFilter(List<double> list) {
    if (list.isEmpty) return [];

    final avg = _average(list);

    final filtered = list.where((value) {
      final diff = (value - avg).abs();
      return diff <= _saltPepperThreshold;
    }).toList();

    return filtered.isEmpty ? list : filtered;
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

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }
}
