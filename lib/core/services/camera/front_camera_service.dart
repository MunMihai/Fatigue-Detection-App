import 'dart:async';
import 'package:camera/camera.dart';
import 'camera_service.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';

class FrontCameraService implements ICameraService {
  CameraController? _controller;
  StreamController<CameraImage>? _frameController;

  @override
  Future<void> initialize() async {
    appLogger.i('[FrontCameraService] Starting initialization...');

    try {
      final cameras = await availableCameras();

      if (cameras.isEmpty) {
        appLogger.e('[FrontCameraService] No cameras available!');
        throw Exception('[FrontCameraService] No cameras available!');
      }

      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () {
          appLogger.e('[FrontCameraService] No front camera found!');
          throw Exception('[FrontCameraService] No front camera found!');
        },
      );

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      _frameController = StreamController<CameraImage>.broadcast();

      await _controller!.initialize();

      appLogger.i('[FrontCameraService] Camera initialized successfully.');
    } catch (e, stack) {
      appLogger.e('[FrontCameraService] Error during camera initialization',
          error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Stream<CameraImage> get frameStream {
    if (_frameController == null) {
      throw Exception('[FrontCameraService] Frame stream is not initialized!');
    }
    return _frameController!.stream;
  }

  @override
  Future<void> startStream() async {
    appLogger.i('[FrontCameraService] Starting image stream...');

    if (_controller == null || !_controller!.value.isInitialized) {
      appLogger.e('[FrontCameraService] Controller is not initialized!');
      throw Exception('[FrontCameraService] Controller is not initialized!');
    }

    if (_controller!.value.isStreamingImages) {
      appLogger.w('[FrontCameraService] Image stream already running!');
      return;
    }

    _controller!.startImageStream((CameraImage image) {
      if (_frameController != null && !_frameController!.isClosed) {
        _frameController!.add(image);
      }
    });

    appLogger.i('[FrontCameraService] Image stream started.');
  }

  @override
  Future<void> stopStream() async {
    appLogger.i('[FrontCameraService] Stopping image stream...');

    if (_controller == null || !_controller!.value.isInitialized) {
      appLogger.w(
          '[FrontCameraService] Controller not initialized, cannot stop stream.');
      return;
    }

    if (_controller!.value.isStreamingImages) {
      await _controller!.stopImageStream();
      appLogger.i('[FrontCameraService] Image stream stopped.');
    } else {
      appLogger.w('[FrontCameraService] Image stream was not running.');
    }
  }

  @override
  Future<void> dispose() async {
    appLogger.i('[FrontCameraService] Disposing camera resources...');

    await stopStream();

    if (_controller != null) {
      await _controller!.dispose();
      _controller = null;
      appLogger.i('[FrontCameraService] CameraController disposed.');
    }

    if (_frameController != null) {
      await _frameController!.close();
      _frameController = null;
      appLogger.i('[FrontCameraService] FrameController closed.');
    }

    appLogger.i('[FrontCameraService] Resources cleaned up successfully.');
  }
}
