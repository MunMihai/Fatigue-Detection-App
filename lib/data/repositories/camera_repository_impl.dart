import 'package:camera/camera.dart';
import 'package:driver_monitoring/data/datasources/camera/camera_datasource.dart';
import 'package:driver_monitoring/domain/repositories/camera_repository.dart';

class CameraRepositoryImpl implements CameraRepository {
  final CameraDataSource dataSource;

  CameraRepositoryImpl(this.dataSource);

  @override
  Future<void> initializeCamera() => dataSource.initializeCamera();

  @override
  Future<void> disposeCamera() => dataSource.disposeCamera();

  @override
  Future<void> setZoom(double zoom) => dataSource.setZoom(zoom);

  @override
  Future<void> setExposure(double exposure) => dataSource.setExposure(exposure);

  @override
  double get currentZoom => dataSource.currentZoom;

  @override
  double get minZoom => dataSource.minZoom;

  @override
  double get maxZoom => dataSource.maxZoom;

  @override
  double get currentExposure => dataSource.currentExposure;

  @override
  double get minExposure => dataSource.minExposure;

  @override
  double get maxExposure => dataSource.maxExposure;

  @override
  CameraController? get controller => dataSource.controller;
}
