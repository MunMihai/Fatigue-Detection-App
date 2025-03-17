import 'package:camera/camera.dart';

abstract class CameraRepository {
  Future<void> initializeCamera();
  Future<void> disposeCamera();

  Future<void> setZoom(double zoom);
  Future<void> setExposure(double exposure);

  double get currentZoom;
  double get minZoom;
  double get maxZoom;

  double get currentExposure;
  double get minExposure;
  double get maxExposure;

  CameraController? get controller;
}
