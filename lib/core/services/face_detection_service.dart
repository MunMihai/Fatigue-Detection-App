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
  static int _closedEyesFrameThreshold = 0;

  DateTime _lastFaceDetectedTime = DateTime.now();

  DateTime? _lastProcessTime;
  static const int _minProcessDelayMs = 100; // 100ms => 10 FPS

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

  DateTime get lastFaceDetectedTime => _lastFaceDetectedTime;

  CustomPaint? get customPaint => _customPaint;
  String? get detectionText => _detectionText;

  void reset(int sensitivity) {
    appLogger.i('[FaceDetectionService] Resetting...');
    closedEyesFrameCounter = 0;
    _customPaint = null;
    _closedEyesFrameThreshold = 11 - sensitivity;
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

    String eyeStatusText = '';
    if (faces.isEmpty) {
      _detectionText = 'No face detected';
      _customPaint = null;
      _isProcessing = false;
      notifyListeners();
      return;
    }
    _lastFaceDetectedTime = DateTime.now(); // ✅ actualizezi aici

    // ✅ Process the largest face only
    faces.sort((a, b) => b.boundingBox.height.compareTo(a.boundingBox.height));
    final face = faces.first;

    final leftEyeOpenProb = face.leftEyeOpenProbability;
    final rightEyeOpenProb = face.rightEyeOpenProbability;

    if (leftEyeOpenProb != null && rightEyeOpenProb != null) {
      final isLeftEyeClosed = leftEyeOpenProb < 0.5;
      final isRightEyeClosed = rightEyeOpenProb < 0.5;

      if (isLeftEyeClosed && isRightEyeClosed) {
        closedEyesFrameCounter++;
        eyeStatusText +=
            '⚠️ Both eyes closed! Frame: $closedEyesFrameCounter\n';
        appLogger.w(eyeStatusText);
      } else {
        eyeStatusText += '👁️ Eyes open:\n';
        eyeStatusText += ' - Left: ${leftEyeOpenProb.toStringAsFixed(2)}\n';
        eyeStatusText += ' - Right: ${rightEyeOpenProb.toStringAsFixed(2)}\n';
        appLogger.i(eyeStatusText);

        closedEyesFrameCounter = 0;
      }
    } else {
      eyeStatusText +=
          '🔍 Eye probabilities unavailable. Adjust face position.\n';
      appLogger.w(eyeStatusText);

      closedEyesFrameCounter++;
    }

    eyeStatusText += 'Face bounds: ${face.boundingBox}\n\n';

    _detectionText = 'Face found\n\n$eyeStatusText';

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

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    super.dispose();
  }
}
