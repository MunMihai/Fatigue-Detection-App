import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

abstract class CameraRepository {
  Future<void> initialize(CameraLensDirection lensDirection);
  Future<void> stop();
  Future<void> setZoom(double value);
  Future<void> setExposure(double value);
  Stream<InputImage> get imageStream;
  ValueNotifier<bool> get previewAvailableNotifier;

  double get currentZoom;
  double get currentExposure;
  double get minZoom;
  double get maxZoom;
  double get minExposure;
  double get maxExposure;

  Widget? get previewWidget;
}
