import 'package:camera/camera.dart';
import 'package:driver_monitoring/core/services/audio_alert_service.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/core/utils/face_detector_painter.dart';

class FaceDetectionService extends ChangeNotifier {
  final FaceDetector _faceDetector;
  final AudioAlertService _audioService;

  bool _canProcess = true;
  bool _isBusy = false;

  CustomPaint? _customPaint;
  String? _text;
  CameraLensDirection _cameraLensDirection = CameraLensDirection.front;

  int closedEyesFrames = 0;
  final int thresholdClosedFrames = 10;

  FaceDetectionService({AudioAlertService? audioService})
      : _audioService = audioService ?? AudioAlertService(),
        _faceDetector = FaceDetector(
          options: FaceDetectorOptions(
            enableContours: true,
            enableLandmarks: true,
            performanceMode: FaceDetectorMode.accurate,
            enableClassification: true,
          ),
        );

  CustomPaint? get customPaint => _customPaint;
  String? get text => _text;
  CameraLensDirection get cameraLensDirection => _cameraLensDirection;

  // ✅ Getter-ul pentru SessionManager
  bool get closedEyesDetected => closedEyesFrames >= thresholdClosedFrames;

  void setCameraLensDirection(CameraLensDirection direction) {
    _cameraLensDirection = direction;
    notifyListeners();
  }

  /// ✅ Metodă pentru reset complet al stării (chemata de SessionManager la inițializare)
  void reset() {
    appLogger.i('[FaceDetectionService] Resetting...');
    closedEyesFrames = 0;
    _audioService.stopAlert();
    _customPaint = null;
    _text = '';
    notifyListeners();
  }

  Future<void> processImage(InputImage inputImage) async {
    if (!_canProcess || _isBusy) return;
    _isBusy = true;

    _text = '';
    notifyListeners();

    final faces = await _faceDetector.processImage(inputImage);

    String eyesStatus = '';

    for (final face in faces) {
      final leftProb = face.leftEyeOpenProbability;
      final rightProb = face.rightEyeOpenProbability;

      if (leftProb != null && rightProb != null) {
        final isLeftEyeClosed = leftProb < 0.5;
        final isRightEyeClosed = rightProb < 0.5;

        if (isLeftEyeClosed && isRightEyeClosed) {
          closedEyesFrames++;
          eyesStatus += '⚠️ Ambii ochi închiși! Frame: $closedEyesFrames\n';
          appLogger.w(eyesStatus);

          if (closedEyesFrames >= thresholdClosedFrames) {
            _audioService.triggerAlert();
          }
        } else {
          eyesStatus += '👁️ Ochi deschiși:\n';
          eyesStatus += ' - Stâng: ${leftProb.toStringAsFixed(2)}\n';
          eyesStatus += ' - Drept: ${rightProb.toStringAsFixed(2)}\n';
          appLogger.i(eyesStatus);

          closedEyesFrames = 0;
          _audioService.stopAlert();
        }
      } else {
        eyesStatus += '🔍 Probabilități indisponibile pentru ochi. Poziționează fața mai bine.\n';
        appLogger.w(eyesStatus);

        closedEyesFrames++;
        if (closedEyesFrames >= thresholdClosedFrames) {
          _audioService.triggerAlert();
        }
      }

      eyesStatus += 'Face bounds: ${face.boundingBox}\n\n';
    }

    _text = 'Faces found: ${faces.length}\n\n$eyesStatus';

    if (inputImage.metadata?.size != null &&
        inputImage.metadata?.rotation != null) {
      final painter = FaceDetectorPainter(
        faces,
        inputImage.metadata!.size,
        inputImage.metadata!.rotation,
        _cameraLensDirection,
      );
      _customPaint = CustomPaint(painter: painter);
    } else {
      _customPaint = null;
    }

    _isBusy = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _canProcess = false;
    _faceDetector.close();
    _audioService.dispose();
    super.dispose();
  }
}
