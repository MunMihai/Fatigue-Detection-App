import 'package:camera/camera.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/domain/entities/alert.dart';
import 'fatigue_detector.dart';

class FrameAnalyzer {
  final FatigueDetector fatigueDetector;

  FrameAnalyzer({required this.fatigueDetector});

  Future<Alert?> analyze(CameraImage frame) async {
    appLogger.t('[FrameAnalyzer] Analyzing frame for fatigue...');
    final alert = await fatigueDetector.detectFatigue(frame);

    if (alert != null) {
      appLogger.w('[FrameAnalyzer] Fatigue detected! ${alert.type}');
      return alert; // Îl poți returna în `SessionManager` ca să adaugi în alertManager
    }

    return null;
  }
}
