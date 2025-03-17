import 'package:driver_monitoring/domain/usecases/camera/set_exposure_usecase.dart';
import 'package:driver_monitoring/domain/usecases/camera/set_zoom_usecase.dart';
import 'package:flutter/material.dart';
import 'package:driver_monitoring/domain/repositories/camera_repository.dart';

class CameraProvider extends ChangeNotifier {
  final SetZoomUseCase setZoomUseCase;
  final SetExposureUseCase setExposureUseCase;
  final CameraRepository cameraRepository;

  CameraProvider({
    required this.setZoomUseCase,
    required this.setExposureUseCase,
    required this.cameraRepository,
  });

  Future<void> setZoom(double zoom) async {
    await setZoomUseCase(zoom);
    notifyListeners(); // UI sliders update
  }

  Future<void> setExposure(double exposure) async {
    await setExposureUseCase(exposure);
    notifyListeners();
  }

  double get currentZoom => cameraRepository.currentZoom;
  double get minZoom => cameraRepository.minZoom;
  double get maxZoom => cameraRepository.maxZoom;

  double get currentExposure => cameraRepository.currentExposure;
  double get minExposure => cameraRepository.minExposure;
  double get maxExposure => cameraRepository.maxExposure;
}
