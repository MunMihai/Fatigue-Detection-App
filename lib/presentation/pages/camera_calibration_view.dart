import 'package:camera/camera.dart';
import 'package:driver_monitoring/presentation/providers/camera_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver_monitoring/core/services/face_detection_service.dart';
import 'package:driver_monitoring/presentation/widgets/app_bar.dart';

class CameraCalibrationView extends StatelessWidget {
  const CameraCalibrationView({super.key});

  @override
  Widget build(BuildContext context) {
    final cameraProvider = context.watch<CameraProvider>();
    final faceDetectionProvider = context.watch<FaceDetectionService>();

    return Scaffold(
      appBar: CustomAppBar(title: 'Camera Calibration'),
      body: !cameraProvider.isCameraReady
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                CameraPreview(
                  cameraProvider.controller!,
                  child: faceDetectionProvider.customPaint,
                ),
                if (cameraProvider.isChangingLens)
                  const Center(child: CircularProgressIndicator()),
                _buildOverlayText(faceDetectionProvider.text),
                _switchCameraButton(context, cameraProvider),
                _zoomSlider(cameraProvider),
                _exposureSlider(cameraProvider),
              ],
            ),
    );
  }

  Widget _buildOverlayText(String? text) {
    return Positioned(
      bottom: 100,
      left: 10,
      child: text != null
          ? Container(
              padding: const EdgeInsets.all(8),
              color: Colors.black54,
              child: Text(text, style: const TextStyle(color: Colors.white)),
            )
          : const SizedBox.shrink(),
    );
  }

  Widget _switchCameraButton(BuildContext context, CameraProvider provider) {
    return Positioned(
      bottom: 8,
      right: 8,
      child: FloatingActionButton(
        onPressed: provider.switchCamera,
        backgroundColor: Colors.black54,
        child: const Icon(Icons.switch_camera, color: Colors.white),
      ),
    );
  }

  Widget _zoomSlider(CameraProvider provider) {
    return Positioned(
      bottom: 16,
      left: 16,
      right: 16,
      child: Column(
        children: [
          const Text('Zoom', style: TextStyle(color: Colors.white)),
          Slider(
            value: provider.currentZoom,
            min: provider.minZoom,
            max: provider.maxZoom,
            onChanged: (value) => provider.setZoomLevel(value),
          ),
        ],
      ),
    );
  }

  Widget _exposureSlider(CameraProvider provider) {
    return Positioned(
      top: 50,
      right: 8,
      child: Column(
        children: [
          const Text('Exposure', style: TextStyle(color: Colors.white)),
          RotatedBox(
            quarterTurns: 3,
            child: Slider(
              value: provider.currentExposure,
              min: provider.minExposure,
              max: provider.maxExposure,
              onChanged: (value) => provider.setExposureOffset(value),
            ),
          ),
        ],
      ),
    );
  }
}
