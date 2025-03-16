import 'package:camera/camera.dart';
import 'package:driver_monitoring/core/utils/convert_camera_image_to_input_image.dart';
import 'package:driver_monitoring/core/services/analysis/fatigue_detector.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/domain/entities/alert.dart';

class FrameAnalyzer {
  final FatigueDetector fatigueDetector;
  final CameraDescription cameraDescription;

  FrameAnalyzer({
    required this.fatigueDetector,
    required this.cameraDescription,
  });

  Future<Alert?> analyze(CameraImage frame) async {
    appLogger.t('[FrameAnalyzer] Converting frame...');

    final inputImage = await convertCameraImageToInputImage(
      frame,
      cameraDescription,
    );

    appLogger
        .t('[FrameAnalyzer] Frame converted. Starting fatigue detection...');

    final alert = await fatigueDetector.detectFatigue(inputImage);

    if (alert != null) {
      appLogger.w('[FrameAnalyzer] Fatigue detected! ${alert.type}');
    }

    return alert;
  }
}
