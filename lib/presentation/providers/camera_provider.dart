import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';

class CameraProvider extends ChangeNotifier {
  Function(InputImage inputImage)? onImageAvailable;

  static List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _cameraIndex = -1;

  double _currentZoomLevel = 1.0;
  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;
  double _minAvailableExposureOffset = 0.0;
  double _maxAvailableExposureOffset = 0.0;
  double _currentExposureOffset = 0.0;

  bool _isCameraStarting = false;

  CameraProvider({this.onImageAvailable});

  CameraController? get controller => _controller;
  bool get isCameraReady =>
      _controller != null && _controller!.value.isInitialized;

  double get currentZoom => _currentZoomLevel;
  double get minZoom => _minAvailableZoom;
  double get maxZoom => _maxAvailableZoom;

  double get currentExposure => _currentExposureOffset;
  double get minExposure => _minAvailableExposureOffset;
  double get maxExposure => _maxAvailableExposureOffset;

  void updateImageCallback(Function(InputImage inputImage) callback) {
    onImageAvailable = callback;
  }

  Future<void> initialize(CameraLensDirection lensDirection) async {
    if (_isCameraStarting) return;

    try {
      _isCameraStarting = true;
      _cameras = await availableCameras();

      final matchingIndex =
          _cameras.indexWhere((cam) => cam.lensDirection == lensDirection);

      if (matchingIndex == -1) {
        debugPrint('❌ Camera with specified lens direction not found.');
        return;
      }

      _cameraIndex = matchingIndex;
      await _startLiveFeed();
    } catch (e) {
      debugPrint('❌ Camera initialization error: $e');
    } finally {
      _isCameraStarting = false;
    }
  }

  Future<void> _startLiveFeed() async {
    final camera = _cameras[_cameraIndex];

    _controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
      imageFormatGroup: Platform.isAndroid
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888,
    );

    try {
      await _controller!.initialize();

      _currentZoomLevel = await _controller!.getMinZoomLevel();
      _minAvailableZoom = _currentZoomLevel;
      _maxAvailableZoom = await _controller!.getMaxZoomLevel();

      _minAvailableExposureOffset = await _controller!.getMinExposureOffset();
      _maxAvailableExposureOffset = await _controller!.getMaxExposureOffset();

      await _controller!.startImageStream(_processCameraImage);

      notifyListeners();
    } catch (e) {
      debugPrint('❌ Failed to start camera live feed: $e');
      await stopCamera();
    }
  }

  Future<void> stopCamera() async {
    if (_controller != null) {
      try {
        if (_controller!.value.isStreamingImages) {
          await _controller!.stopImageStream();
        }

        await _controller!.dispose();
        debugPrint('✅ Camera stopped and disposed.');
      } catch (e) {
        debugPrint('❌ Error stopping camera: $e');
      } finally {
        _controller = null;
        notifyListeners();
      }
    }
  }

  Future<void> setZoomLevel(double value) async {
    _currentZoomLevel = value;
    try {
      await _controller?.setZoomLevel(value);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Failed to set zoom: $e');
    }
  }

  Future<void> setExposureOffset(double value) async {
    _currentExposureOffset = value;
    try {
      await _controller?.setExposureOffset(value);
      notifyListeners();
    } catch (e) {
      debugPrint('❌ Failed to set exposure: $e');
    }
  }

  void _processCameraImage(CameraImage image) {
    final inputImage = convertCameraImage(image);
    if (inputImage != null && onImageAvailable != null) {
      onImageAvailable!(inputImage);
    }
  }

  InputImage? convertCameraImage(CameraImage image) {
    if (_controller == null) return null;

    final camera = _cameras[_cameraIndex];
    final sensorOrientation = camera.sensorOrientation;

    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      final orientations = {
        DeviceOrientation.portraitUp: 0,
        DeviceOrientation.landscapeLeft: 90,
        DeviceOrientation.portraitDown: 180,
        DeviceOrientation.landscapeRight: 270,
      };

      var rotationCompensation =
          orientations[_controller!.value.deviceOrientation];
      if (rotationCompensation == null) return null;

      if (camera.lensDirection == CameraLensDirection.front) {
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }

      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
    }

    if (rotation == null) return null;

    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) {
      return null;
    }

    if (image.planes.length != 1) return null;

    final plane = image.planes.first;

    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation,
        format: format,
        bytesPerRow: plane.bytesPerRow,
      ),
    );
  }

  @override
  void dispose() {
    stopCamera();
    super.dispose();
  }
}
