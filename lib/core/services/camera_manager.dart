import 'package:driver_monitoring/core/services/camera/camera_service.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:flutter/foundation.dart';

class CameraManager extends ChangeNotifier {
  final ICameraService cameraService;

  bool _isStreaming = false;

  CameraManager({
    required this.cameraService,
  }) {
    appLogger.i('[CameraManager] Created with ${cameraService.runtimeType}');
  }

  bool get isStreaming => _isStreaming;

  Future<void> initializeCamera() async {
    appLogger.i('[CameraManager] Initializing camera...');

    try {
      await cameraService.initialize();
      appLogger.i('[CameraManager] Camera initialized successfully.');
    } catch (e, stackTrace) {
      appLogger.e('[CameraManager] Error initializing camera', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> startCapturing() async {
    if (_isStreaming) {
      appLogger.w('[CameraManager] Already streaming. Ignoring start.');
      return;
    }

    appLogger.i('[CameraManager] Starting capture...');
    try {
      await cameraService.startStream();
      _isStreaming = true;
      appLogger.i('[CameraManager] Capture started successfully.');
      notifyListeners();
    } catch (e, stackTrace) {
      appLogger.e('[CameraManager] Error starting capture', error: e, stackTrace: stackTrace);
    }
  }

  Future<void> stopCapturing() async {
    if (!_isStreaming) {
      appLogger.w('[CameraManager] Not streaming. Ignoring stop.');
      return;
    }

    appLogger.i('[CameraManager] Stopping capture...');
    try {
      await cameraService.stopStream();
      _isStreaming = false;
      appLogger.i('[CameraManager] Capture stopped successfully.');
      notifyListeners();
    } catch (e, stackTrace) {
      appLogger.e('[CameraManager] Error stopping capture', error: e, stackTrace: stackTrace);
    }
  }

  Stream<Object> get frameStream {
    appLogger.t('[CameraManager] Accessed frame stream.');
    return cameraService.frameStream;
  }

  Future<void> disposeCamera() async {
    appLogger.i('[CameraManager] Disposing camera...');

    try {
      if (_isStreaming) {
        await stopCapturing();
      }

      await cameraService.dispose();

      _isStreaming = false;
      appLogger.i('[CameraManager] Camera disposed successfully.');
    } catch (e, stackTrace) {
      appLogger.e('[CameraManager] Error disposing camera', error: e, stackTrace: stackTrace);
    }
  }

  @override
  void dispose() {
    appLogger.i('[CameraManager] Disposing CameraManager...');

    disposeCamera(); // ⚠️ Important să-l chemi aici!
    super.dispose();
  }
}
