import 'package:driver_monitoring/domain/enum/alert_type.dart';

import 'alert_strategy.dart';
import 'package:driver_monitoring/domain/services/face_detection_service.dart';

class YawningAlert implements AlertStrategy {
  final FaceDetectionService faceDetectionService;
  final List<DateTime> _timestamps = [];
  bool _isYawningActive = false;

  YawningAlert(this.faceDetectionService);

  @override
  AlertType get type => AlertType.yawning;

  @override
  double get severity => 180;

  @override
  bool shouldTrigger() {
    final currentTime = DateTime.now();
    _timestamps.removeWhere((t) => currentTime.difference(t).inSeconds > 60);

    if (faceDetectionService.yawningDetected) {
      if (!_isYawningActive) {
        _timestamps.add(currentTime);
        _isYawningActive = true;
      }
    } else {
      _isYawningActive = false;
    }

    return _timestamps.length >= 3 && _isYawningActive;
  }

  @override
  void reset() {
    _timestamps.clear();
    _isYawningActive = false;
  }
}
