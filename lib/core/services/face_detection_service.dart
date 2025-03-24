import 'package:camera/camera.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/core/utils/face_detector_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectionService extends ChangeNotifier {
  static const int _minProcessDelayMs = 100;
  static const double _yawnOpenThreshold = 0.3;
  static const double _noseDistanceThreshold = 1.2;
  static const double _eyeOpenTreshold = 0.4;
  static const double _eyesOpenDifference = 0.2;
  

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
            performanceMode: FaceDetectorMode.accurate,
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

    _closedEyesFrameThreshold = (12 - sensitivity);
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
      final difference = (leftEyeOpenProb - rightEyeOpenProb).abs();

      final bothEyesClosed = leftEyeOpenProb < _eyeOpenTreshold &&
          rightEyeOpenProb < _eyeOpenTreshold &&
          difference <= _eyesOpenDifference;

      if (bothEyesClosed) {
        closedEyesFrameCounter++;
        final text = '⚠️ Both eyes closed! Frame: $closedEyesFrameCounter';
        appLogger.w(text);
        return text;
      } else {
        closedEyesFrameCounter = 0;
        final text =
            '👁️ Eyes open\n - Left: ${leftEyeOpenProb.toStringAsFixed(2)}'
            '\n - Right: ${rightEyeOpenProb.toStringAsFixed(2)}';
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
