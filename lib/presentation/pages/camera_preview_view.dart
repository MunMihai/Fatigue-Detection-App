import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:driver_monitoring/presentation/providers/camera_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CameraPreviewView extends StatelessWidget {
  const CameraPreviewView({super.key});

  @override
  Widget build(BuildContext context) {
    final cameraProvider = context.watch<CameraProvider>();
    final tr = AppLocalizations.of(context)!;

    final customPaint = cameraProvider.customPaint;
    final detectionText = cameraProvider.detectionText;

    return Scaffold(
      body: ValueListenableBuilder<bool>(
        valueListenable: cameraProvider.isCameraActive,
        builder: (context, isActive, _) {
          final preview = cameraProvider.previewWidget;

          if (!isActive || preview == null) {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            );
          }

          return Stack(
            fit: StackFit.expand,
            children: [
              preview,
              if (customPaint != null) customPaint,
              _buildOverlayText(detectionText),
              _zoomSlider(tr, cameraProvider),
              _exposureSlider(tr, cameraProvider),
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

  Widget _zoomSlider(AppLocalizations tr, CameraProvider provider) {
    return Positioned(
      bottom: 8,
      left: 32,
      right: 32,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr.zoom, style: TextStyle(color: Colors.white)),
          Slider(
            value: provider.currentZoom,
            min: provider.minZoom,
            max: provider.maxZoom,
            onChanged: (value) => provider.setZoom(value),
          ),
        ],
      ),
    );
  }

  Widget _exposureSlider(AppLocalizations tr, CameraProvider provider) {
    return Positioned(
      top: 8,
      right: 8,
      child: Column(
        children: [
          Text(tr.exposure, style: TextStyle(color: Colors.white)),
          RotatedBox(
            quarterTurns: 3,
            child: Slider(
              value: provider.currentExposure,
              min: provider.minExposure,
              max: provider.maxExposure,
              onChanged: (value) => provider.setExposure(value),
            ),
          ),
        ],
      ),
    );
  }
}
