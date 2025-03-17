import 'package:camera/camera.dart';
import 'package:driver_monitoring/presentation/pages/camera/camera_view.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class DetectorView extends StatelessWidget {
  const DetectorView({
    super.key,
    required this.title,
    required this.onImage,
    this.customPaint,
    this.text,
    this.initialCameraLensDirection = CameraLensDirection.back,
    this.onCameraFeedReady,
    this.onCameraLensDirectionChanged,
  });

  final String title;
  final CustomPaint? customPaint;
  final String? text;
  final Function(InputImage inputImage) onImage;
  final Function()? onCameraFeedReady;
  final Function(CameraLensDirection direction)? onCameraLensDirectionChanged;
  final CameraLensDirection initialCameraLensDirection;

  @override
  Widget build(BuildContext context) {
    return CameraView(
      customPaint: customPaint, // direct
      onImage: onImage,
      onCameraFeedReady: onCameraFeedReady,
      initialCameraLensDirection: initialCameraLensDirection,
      onCameraLensDirectionChanged: onCameraLensDirectionChanged,
    );
  }
}
