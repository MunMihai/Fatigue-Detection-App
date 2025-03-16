import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver_monitoring/core/services/analysis/frame_processor.dart';

class ProcessedImageWidget extends StatelessWidget {
  const ProcessedImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final frameProcessor = context.read<FrameProcessor>();

    return ValueListenableBuilder<Uint8List?>(
      valueListenable: frameProcessor.processedImageNotifier,
      builder: (context, processedImage, _) {
        if (processedImage == null) {
          return const Center(child: Text('No processed image', style: TextStyle(color: Colors.white)));
        }

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.memory(processedImage, fit: BoxFit.cover),
        );
      },
    );
  }
}
