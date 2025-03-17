import 'package:camera/camera.dart';
import 'package:driver_monitoring/data/datasources/camera/camera_datasource.dart';

class FrontCameraDataSourceImpl implements CameraDataSource {
  CameraController? _controller;

  double _currentZoom = 1.0;
  double _minZoom = 1.0;
  double _maxZoom = 1.0;

  double _currentExposure = 0.0;
  double _minExposure = 0.0;
  double _maxExposure = 0.0;

  @override
  CameraController? get controller => _controller;

  @override
  double get currentZoom => _currentZoom;

  @override
  double get minZoom => _minZoom;

  @override
  double get maxZoom => _maxZoom;

  @override
  double get currentExposure => _currentExposure;

  @override
  double get minExposure => _minExposure;

  @override
  double get maxExposure => _maxExposure;

  @override
  Future<void> initializeCamera() async {
    final cameras = await availableCameras();
    final frontCamera = cameras.firstWhere(
      (camera) => camera.lensDirection == CameraLensDirection.front,
    );

    _controller = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _controller!.initialize();

    _minZoom = await _controller!.getMinZoomLevel();
    _maxZoom = await _controller!.getMaxZoomLevel();

    _minExposure = await _controller!.getMinExposureOffset();
    _maxExposure = await _controller!.getMaxExposureOffset();

    _currentZoom = _minZoom;
    _currentExposure = 0.0;
  }

  @override
  Future<void> disposeCamera() async {
    await _controller?.dispose();
    _controller = null;
  }

  @override
  Future<void> setZoom(double zoom) async {
    if (_controller != null && _controller!.value.isInitialized) {
      await _controller!.setZoomLevel(zoom);
      _currentZoom = zoom;
    }
  }

  @override
  Future<void> setExposure(double exposure) async {
    if (_controller != null && _controller!.value.isInitialized) {
      await _controller!.setExposureOffset(exposure);
      _currentExposure = exposure;
    }
  }
}