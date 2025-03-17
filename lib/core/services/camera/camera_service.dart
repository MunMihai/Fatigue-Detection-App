import 'package:camera/camera.dart';

abstract class CameraService {
  Future<void> initialize();
  void dispose();

  CameraController? get controller;

  Future<void> setZoom(double zoom);
  Future<void> toggleTorch();
  Future<void> setExposure(double exposure);
  bool get isTorchOn;
}
