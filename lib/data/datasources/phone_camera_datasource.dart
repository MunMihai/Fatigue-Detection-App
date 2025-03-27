import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/data/datasources/camera_datasource.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'package:driver_monitoring/core/utils/camera_image_convertor.dart';

class PhoneCameraDataSource implements CameraDataSource {
  late List<CameraDescription> _cameras;
  CameraController? _controller;
  int _cameraIndex = -1;

  StreamController<InputImage>? _imageStreamController;

  double _currentZoom = 1.0;
  double _minZoom = 1.0;
  double _maxZoom = 1.0;
  double _currentExposure = 0.0;
  double _minExposure = 0.0;
  double _maxExposure = 0.0;

  CameraController? get debugController => _controller;

  @override
  final ValueNotifier<bool> previewAvailableNotifier = ValueNotifier(false);

  @override
  double get currentZoom => _currentZoom;
  @override
  double get currentExposure => _currentExposure;
  @override
  double get minZoom => _minZoom;
  @override
  double get maxZoom => _maxZoom;
  @override
  double get minExposure => _minExposure;
  @override
  double get maxExposure => _maxExposure;

  @override
  Stream<InputImage> get imageStream => _imageStreamController!.stream;

  @override
  Future<void> initialize(CameraLensDirection lensDirection) async {
    if (_imageStreamController == null || _imageStreamController!.isClosed) {
      _imageStreamController = StreamController<InputImage>.broadcast();
    }

    _cameras = await availableCameras();
    _cameraIndex =
        _cameras.indexWhere((cam) => cam.lensDirection == lensDirection);
    if (_cameraIndex == -1) throw Exception('Camera not found');

    final camera = _cameras[_cameraIndex];
    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    await _controller!.initialize();

    previewAvailableNotifier.value = true;

    _currentZoom = await _controller!.getMinZoomLevel();
    _minZoom = _currentZoom;
    _maxZoom = await _controller!.getMaxZoomLevel();

    _minExposure = await _controller!.getMinExposureOffset();
    _maxExposure = await _controller!.getMaxExposureOffset();

    await _controller!.startImageStream(_onImageAvailable);
  }

  void _onImageAvailable(CameraImage image) {
    if (_controller == null ||
        _imageStreamController == null ||
        _imageStreamController!.isClosed) {
      return;
    }

    final inputImage = CameraImageConverter.convert(
      image,
      controller: _controller!,
      cameras: _cameras,
      cameraIndex: _cameraIndex,
    );
    if (inputImage != null) {
      _imageStreamController!.add(inputImage);
    }
  }

  @override
  Future<void> stop() async {
    if (_controller != null) {
      if (_controller!.value.isStreamingImages) {
        await _controller!.stopImageStream();
      }
      previewAvailableNotifier.value = false;

      await _controller!.dispose();
      _controller = null;
    }

    if (_imageStreamController != null && !_imageStreamController!.isClosed) {
      await _imageStreamController!.close();
    }

    _imageStreamController = null;
  }

  @override
  Future<void> setZoom(double value) async {
    _currentZoom = value;
    await _controller?.setZoomLevel(value);
  }

  @override
  Future<void> setExposure(double value) async {
    _currentExposure = value;
    await _controller?.setExposureOffset(value);
  }

  @override
  Widget? buildPreviewWidget() {
    return ValueListenableBuilder<bool>(
      valueListenable: previewAvailableNotifier,
      builder: (context, isActive, _) {
        if (!isActive ||
            _controller == null ||
            !_controller!.value.isInitialized) {
          return const SizedBox(); // Sau loading
        }

        try {
          return CameraPreview(_controller!);
        } catch (e) {
          appLogger.e('❌ Error building preview: $e');
          return const Center(child: Text('Preview error'));
        }
      },
    );
  }
}
