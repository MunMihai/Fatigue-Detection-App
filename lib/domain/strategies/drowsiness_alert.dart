import 'alert_strategy.dart';
import 'package:driver_monitoring/domain/enum/alert_type.dart';
import 'package:driver_monitoring/domain/services/face_detection_service.dart';

class DrowsinessAlert implements AlertStrategy {
  final FaceDetectionService faceDetectionService;

  DrowsinessAlert(this.faceDetectionService);

  @override
  AlertType get type => AlertType.drowsiness;

  @override
  double get severity => 360;

  @override
  bool shouldTrigger() {
    return faceDetectionService.closedEyesDetected;
  }
  
  @override
  void reset() {
    // TODO: implement reset
  }
}
