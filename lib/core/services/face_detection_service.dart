import 'package:camera/camera.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/core/utils/face_detector_painter.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class FaceDetectionService extends ChangeNotifier {
  final FaceDetector _faceDetector;
  final CameraLensDirection _cameraLensDirection = CameraLensDirection.front;

  bool _canProcess = true;
  bool _isProcessing = false;

  CustomPaint? _customPaint;
  String? _detectionText;

  int closedEyesFrameCounter = 0;
  int yawnFrameCounter = 0;
  static int _closedEyesFrameThreshold = 0;
  static int _yawnFrameThreshold = 0;

  static const double _yawnOpenThreshold = 0.4;
  static const double _noseDistanceThreshold = 0.8;

  DateTime _lastFaceDetectedTime = DateTime.now();
  DateTime? _lastProcessTime;
  static const int _minProcessDelayMs = 100;

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
  
    _closedEyesFrameThreshold = 13 - sensitivity;
    _yawnFrameThreshold = (7 - sensitivity).clamp(3, 10); 
    _detectionText = '';
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
      _detectionText = 'No face detected';
      _customPaint = null;
      _isProcessing = false;
      notifyListeners();
      return;
    }

    _lastFaceDetectedTime = DateTime.now();

    // ✅ Process the largest face only
    faces.sort((a, b) => b.boundingBox.height.compareTo(a.boundingBox.height));
    final face = faces.first;

    // 🔸 Detect eyes and yawning (separate methods)
    final eyeStatusText = _processEyeState(face);
    final yawnStatusText = _processYawning(face);

    _detectionText = 'Face found\n\n$eyeStatusText\n$yawnStatusText';

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = FaceDetectorPainter(
        [face],
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      _customPaint = null;
    }

    _isProcessing = false;
    notifyListeners();
  }

  /// 🔹 Procesează starea ochilor (închiși / deschiși)
  String _processEyeState(Face face) {
    String eyeStatusText = '';
    final leftEyeOpenProb = face.leftEyeOpenProbability;
    final rightEyeOpenProb = face.rightEyeOpenProbability;

    if (leftEyeOpenProb != null && rightEyeOpenProb != null) {
      final isLeftEyeClosed = leftEyeOpenProb < 0.5;
      final isRightEyeClosed = rightEyeOpenProb < 0.5;

      if (isLeftEyeClosed && isRightEyeClosed) {
        closedEyesFrameCounter++;
        eyeStatusText = '⚠️ Both eyes closed! Frame: $closedEyesFrameCounter';
        appLogger.w(eyeStatusText);
      } else {
        eyeStatusText =
            '👁️ Eyes open\n - Left: ${leftEyeOpenProb.toStringAsFixed(2)}\n - Right: ${rightEyeOpenProb.toStringAsFixed(2)}';
        closedEyesFrameCounter = 0;
        appLogger.i(eyeStatusText);
      }
    } else {
      closedEyesFrameCounter++;
      eyeStatusText = '🔍 Eye probabilities unavailable.';
      appLogger.w(eyeStatusText);
    }

    return eyeStatusText;
  }

  String _processYawning(Face face) {
    String yawnStatusText = '';

    final landmarks = face.landmarks;

    final bottomMouth = landmarks[FaceLandmarkType.bottomMouth]?.position;
    final leftMouth = landmarks[FaceLandmarkType.rightMouth]?.position;
    final rightMouth = landmarks[FaceLandmarkType.leftMouth]?.position;
    final noseBase = landmarks[FaceLandmarkType.noseBase]?.position;

    if (bottomMouth != null &&
        leftMouth != null &&
        rightMouth != null &&
        noseBase != null) {
      final mouthWidth = (leftMouth.x - rightMouth.x).abs();
      final mouthHeight =
          (bottomMouth.y - ((leftMouth.y + rightMouth.y) / 2)).abs();
      final noseToMouthDistance = (bottomMouth.y - noseBase.y).abs();

      final mouthOpenRatio = mouthHeight / mouthWidth;
      final noseMouthRatio = noseToMouthDistance / mouthWidth;

      // Parametri reglabili pe baza testelor
      bool isYawning = (mouthOpenRatio > _yawnOpenThreshold) &&
          (noseMouthRatio > _noseDistanceThreshold);

      yawnStatusText = isYawning
          ? '😮 Yawning detected! MouthRatio: ${mouthOpenRatio.toStringAsFixed(2)} | NoseRatio: ${noseMouthRatio.toStringAsFixed(2)}'
          : '🙂 No yawning. MouthRatio: ${mouthOpenRatio.toStringAsFixed(2)} | NoseRatio: ${noseMouthRatio.toStringAsFixed(2)}';

      if (isYawning) {
        yawnFrameCounter++;
        appLogger.w(yawnStatusText);
      } else {
        yawnFrameCounter = 0;
        appLogger.i(yawnStatusText);
      }
    } else {
      yawnStatusText = '❗ Required landmarks not found (nose/mouth)';
      appLogger.w(yawnStatusText);
    }

    return yawnStatusText;
  }

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }
}
