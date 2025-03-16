import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver_monitoring/core/services/camera_manager.dart';

class CameraPreviewWidget extends StatelessWidget {
  const CameraPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cameraManager = context.watch<CameraManager>();
    final previewData = cameraManager.previewData; // Nou getter definit în ICameraService

    if (previewData == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (previewData is CameraController) {
      final controller = previewData;
      if (!controller.value.isInitialized) {
        return const Center(child: CircularProgressIndicator());
      }

      return AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      );
    }

    return const Center(child: Text("Preview not supported for this camera type."));
  }
}
