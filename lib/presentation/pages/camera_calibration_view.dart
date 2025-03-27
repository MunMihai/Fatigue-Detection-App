import 'package:camera/camera.dart';
import 'package:driver_monitoring/presentation/providers/camera_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver_monitoring/presentation/widgets/app_bar.dart';

class CameraCalibrationView extends StatelessWidget {
  const CameraCalibrationView({super.key});

  @override
  Widget build(BuildContext context) {
    final cameraProvider = context.watch<CameraProvider>();

    final customPaint = cameraProvider.customPaint;
    final detectionText = cameraProvider.detectionText;
    final controller = cameraProvider.controller;

    return Scaffold(
      appBar: CustomAppBar(title: 'Camera Preview'),
      body: controller == null || !controller.value.isInitialized
          ? const Center(child: Text('Camera not initialized'))
          : ValueListenableBuilder<CameraValue>(
              valueListenable: controller,
              builder: (context, value, child) {
                if (!value.isInitialized) {
                  return const Center(child: CircularProgressIndicator());
                }

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    if (controller.value.isStreamingImages)
                      CameraPreview(
                        controller,
                        child: customPaint,
                      )
                    else
                      const Center(child: Text('Camera stopped')),
                    _buildOverlayText(detectionText),
                    _zoomSlider(cameraProvider),
                    _exposureSlider(cameraProvider),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildOverlayText(String? text) {
    if (text == null || text.isEmpty) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 100,
      left: 10,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black54,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }

  Widget _zoomSlider(CameraProvider provider) {
    return Positioned(
      bottom: 8,
      left: 32,
      right: 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
      top: 8,
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
