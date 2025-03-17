import 'package:camera/camera.dart';
import 'camera_service.dart';

class FrontCameraService implements CameraService {
  late CameraController _controller;
  @override
  CameraController? get controller => _controller;

  bool _isTorchOn = false;

  @override
  bool get isTorchOn => _isTorchOn;

  @override
  Future<void> initialize() async {
    final cameras = await availableCameras();

    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
  }

  @override
  Future<void> setZoom(double zoom) async {
    if (_controller.value.isInitialized) {
      final minZoom = await _controller.getMinZoomLevel();
      final maxZoom = await _controller.getMaxZoomLevel();

      if (zoom >= minZoom && zoom <= maxZoom) {
        await _controller.setZoomLevel(zoom);
      }
    }
  }

  @override
  Future<void> toggleTorch() async {
    if (_controller.value.isInitialized) {
      if (_isTorchOn) {
        await _controller.setFlashMode(FlashMode.off);
        _isTorchOn = false;
      } else {
        await _controller.setFlashMode(FlashMode.torch);
        _isTorchOn = true;
      }
    }
  }

  @override
  Future<void> setExposure(double exposure) async {
    if (_controller.value.isInitialized) {
      final minExposure = await _controller.getMinExposureOffset();
      final maxExposure = await _controller.getMaxExposureOffset();

      if (exposure >= minExposure && exposure <= maxExposure) {
        await _controller.setExposureOffset(exposure);
      }
    }
  }
}
