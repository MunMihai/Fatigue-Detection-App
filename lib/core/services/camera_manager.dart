import 'package:driver_monitoring/core/services/camera/camera_service.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:flutter/foundation.dart';

class CameraManager extends ChangeNotifier {
  final ICameraService cameraService;

  bool _isStreaming = false;

  CameraManager({required this.cameraService}) {
    appLogger.i('[CameraManager] Created with ${cameraService.runtimeType}');
  }

  bool get isStreaming => _isStreaming;

  Object? get previewData => cameraService.previewData;

  Future<void> initializeCamera() async {
    appLogger.i('[CameraManager] Initializing camera...');
    try {
      await cameraService.initialize();
      appLogger.i('Camera initialized successfully.');
    } catch (e, stackTrace) {
      appLogger.e('Error initializing camera', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> startCapturing() async {
    if (_isStreaming) {
      appLogger.w('Already streaming. Ignoring start.');
      return;
    }

    appLogger.i('Starting capture...');
    try {
      await cameraService.startStream();
      _isStreaming = true;
      appLogger.i('Capture started successfully.');
      notifyListeners();
    } catch (e, stackTrace) {
      appLogger.e('Error starting capture', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> stopCapturing() async {
    if (!_isStreaming) {
      appLogger.w('Not streaming. Ignoring stop.');
      return;
    }

    appLogger.i('Stopping capture...');
    try {
      await cameraService.stopStream();
      _isStreaming = false;
      appLogger.i('Capture stopped successfully.');
      notifyListeners();
    } catch (e, stackTrace) {
      appLogger.e('Error stopping capture', error: e, stackTrace: stackTrace);
    }
  }

  Stream<Object> get frameStream {
    appLogger.t('Accessed frame stream.');
    return cameraService.frameStream;
  }

  Future<void> disposeCamera() async {
    appLogger.i('Disposing camera...');

    try {
      if (_isStreaming) {
        await stopCapturing();
      }

      await cameraService.dispose();

      _isStreaming = false;
      appLogger.i('Camera disposed successfully.');
    } catch (e, stackTrace) {
      appLogger.e('Error disposing camera', error: e, stackTrace: stackTrace);
    }
  }

  @override
  void dispose() {
    appLogger.i('Disposing CameraManager...');
    disposeCamera();
    super.dispose();
  }
}
