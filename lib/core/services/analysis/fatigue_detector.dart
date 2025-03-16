import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:driver_monitoring/domain/entities/alert.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';

class FatigueDetector {
  final FaceDetector _faceDetector;

  FatigueDetector()
      : _faceDetector = FaceDetector(
          options: FaceDetectorOptions(
            enableClassification: true, // Necesită pentru probabilități (ochi/gură)
            enableTracking: false,
            performanceMode: FaceDetectorMode.fast,
          ),
        );

  Future<Alert?> detectFatigue(InputImage inputImage) async {
    try {
      final List<Face> faces = await _faceDetector.processImage(inputImage);

      if (faces.isEmpty) {
        appLogger.t('[FatigueDetector] No faces detected');
        return null;
      }

      final face = faces.first;

      final leftEyeOpenProb = face.leftEyeOpenProbability ?? 1.0;
      final rightEyeOpenProb = face.rightEyeOpenProbability ?? 1.0;
      final smilingProb = face.smilingProbability ?? 0.0;

      appLogger.t('[FatigueDetector] Left Eye Open Prob: $leftEyeOpenProb');
      appLogger.t('[FatigueDetector] Right Eye Open Prob: $rightEyeOpenProb');
      appLogger.t('[FatigueDetector] Smiling Prob: $smilingProb');

      // Condiții simple pentru exemplu
      if (leftEyeOpenProb < 0.4 && rightEyeOpenProb < 0.4) {
        appLogger.w('[FatigueDetector] Eyes closed detected');
        return Alert(
          id: 'eyes-closed-${DateTime.now().microsecondsSinceEpoch}',
          timestamp: DateTime.now(),
          severity: 0.8,
          type: 'Eyes Closed Detected',
        );
      }

      // În lipsa altui atribut pentru căscat, putem folosi smilingProbability pentru demo.
      if (smilingProb < 0.1) {
        appLogger.w('[FatigueDetector] Yawning detected (low smiling probability)');
        return Alert(
          id: 'yawning-${DateTime.now().microsecondsSinceEpoch}',
          timestamp: DateTime.now(),
          severity: 0.6,
          type: 'Possible Yawning Detected',
        );
      }

      return null;
    } catch (e, stackTrace) {
      appLogger.e('[FatigueDetector] Error processing image', error: e, stackTrace: stackTrace);
      return null;
    }
  }

  Future<void> dispose() async {
    await _faceDetector.close();
  }
}
