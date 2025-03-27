import 'package:camera/camera.dart';
import 'package:driver_monitoring/data/datasources/camera_datasource.dart';
import 'package:driver_monitoring/domain/repositories/camera_repository.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

class CameraRepositoryImpl implements CameraRepository {
  final CameraDataSource dataSource;

  CameraRepositoryImpl(this.dataSource);

  @override
  Future<void> initialize(CameraLensDirection lensDirection) =>
      dataSource.initialize(lensDirection);

  @override
  Future<void> stop() => dataSource.stop();

  @override
  Future<void> setZoom(double value) => dataSource.setZoom(value);

  @override
  Future<void> setExposure(double value) => dataSource.setExposure(value);

  @override
  Stream<InputImage> get imageStream => dataSource.imageStream;

  @override
  double get currentZoom => dataSource.currentZoom;

  @override
  double get currentExposure => dataSource.currentExposure;

  @override
  double get minZoom => dataSource.minZoom;

  @override
  double get maxZoom => dataSource.maxZoom;

  @override
  double get minExposure => dataSource.minExposure;

  @override
  double get maxExposure => dataSource.maxExposure;
  @override
  Widget? get previewWidget => dataSource.buildPreviewWidget();

  @override
  ValueNotifier<bool> get previewAvailableNotifier =>
      dataSource.previewAvailableNotifier;
}
