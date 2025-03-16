import 'dart:async';
import 'package:camera/camera.dart';
import 'package:driver_monitoring/core/services/analysis/frame_analyzer.dart';
import 'package:driver_monitoring/core/services/camera_manager.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/domain/entities/alert.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart' as img;

class FrameProcessor extends ChangeNotifier {
  CameraManager cameraManager;
  FrameAnalyzer frameAnalyzer;
  final Function(Alert) onAlertDetected;

  StreamSubscription? _frameSubscription;
  bool _isProcessingFrame = false;

  ValueNotifier<Uint8List?> processedImageNotifier = ValueNotifier(null);

  FrameProcessor({
    required this.cameraManager,
    required this.frameAnalyzer,
    required this.onAlertDetected,
  });

  void update({required CameraManager cameraManager, required FrameAnalyzer frameAnalyzer}) {
    this.cameraManager = cameraManager;
    this.frameAnalyzer = frameAnalyzer;
    notifyListeners();
  }

  Future<void> start() async {
    appLogger.i('[FrameProcessor] Subscribing to frame stream...');
    await _frameSubscription?.cancel();

    _frameSubscription = cameraManager.frameStream.listen(
      (frame) => _processFrame(frame),
      onError: (error, stack) => appLogger.e('[FrameProcessor] Error in frame stream', error: error, stackTrace: stack),
      cancelOnError: false,
    );
  }

  Future<void> stop() async {
    appLogger.i('[FrameProcessor] Stopping frame processing...');
    await _frameSubscription?.cancel();
    _frameSubscription = null;
  }

  Future<void> _processFrame(Object frame) async {
    if (_isProcessingFrame) return;
    _isProcessingFrame = true;

    try {
      appLogger.t('[FrameProcessor] Processing frame...');
      if (frame is CameraImage) {
        final alert = await frameAnalyzer.analyze(frame);
        if (alert != null) onAlertDetected(alert);

        final processedBytes = await _convertCameraImageToDisplay(frame);
        processedImageNotifier.value = processedBytes;
      }
    } catch (e, stackTrace) {
      appLogger.e('[FrameProcessor] Error analyzing frame', error: e, stackTrace: stackTrace);
    } finally {
      _isProcessingFrame = false;
    }
  }

  Future<Uint8List> _convertCameraImageToDisplay(CameraImage image) async {
    final width = image.width;
    final height = image.height;
    final imgBuffer = img.Image(width: width, height: height);
    final yPlane = image.planes[0];

    for (int y = 0; y < height; y++) {
      for (int x = 0; x < width; x++) {
        final pixel = yPlane.bytes[y * yPlane.bytesPerRow + x];
        imgBuffer.setPixelRgb(x, y, pixel, pixel, pixel);
      }
    }

    return Uint8List.fromList(img.encodeJpg(imgBuffer));
  }

  @override
  void dispose() {
    processedImageNotifier.dispose();
    stop();
    super.dispose();
  }
}
