import 'package:camera/camera.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/domain/repositories/camera_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

class CameraProvider extends ChangeNotifier {
  final CameraRepository _cameraRepository;

  Stream<InputImage>? _imageStream;
  CustomPaint? _customPaint;
  String? _detectionText;

  bool _isInitializing = false;

  CameraProvider(this._cameraRepository);

  bool get isCameraReady => _imageStream != null;

  ValueNotifier<bool> get isCameraActive =>
      _cameraRepository.previewAvailableNotifier;
  Widget? get previewWidget => _cameraRepository.previewWidget;

  CustomPaint? get customPaint => _customPaint;
  String? get detectionText => _detectionText;

  double get currentZoom => _cameraRepository.currentZoom;
  double get minZoom => _cameraRepository.minZoom;
  double get maxZoom => _cameraRepository.maxZoom;

  double get currentExposure => _cameraRepository.currentExposure;
  double get minExposure => _cameraRepository.minExposure;
  double get maxExposure => _cameraRepository.maxExposure;

  Stream<InputImage>? get imageStream => _imageStream;

  Future<void> initialize(CameraLensDirection lensDirection) async {
    if (_isInitializing) return;
    _isInitializing = true;

    try {
      await _cameraRepository.initialize(lensDirection);
      _imageStream = _cameraRepository.imageStream;
      notifyListeners();
    } catch (e) {
      appLogger.e('❌ Camera init error: $e');
    } finally {
      _isInitializing = false;
    }
  }

  Future<void> stopCamera() async {
    await _cameraRepository.stop();
    _imageStream = null;
    notifyListeners();
  }

  Future<void> setZoom(double value) async {
    try {
      await _cameraRepository.setZoom(value);
      notifyListeners();
    } catch (e) {
      appLogger.e('❌ Failed to set zoom: $e');
    }
  }

  Future<void> setExposure(double value) async {
    try {
      await _cameraRepository.setExposure(value);
      notifyListeners();
    } catch (e) {
      appLogger.e('❌ Failed to set exposure: $e');
    }
  }

  void updateFromDetection({CustomPaint? paint, String? text}) {
    bool changed = false;

    if (_customPaint != paint) {
      _customPaint = paint;
      changed = true;
    }

    if (_detectionText != text) {
      _detectionText = text;
      changed = true;
    }

    if (changed) notifyListeners();
  }

  @override
  void dispose() {
    stopCamera();
    super.dispose();
  }
}
