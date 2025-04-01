import 'package:driver_monitoring/domain/enum/alert_type.dart';

abstract class AlertStrategy {
  AlertType get type;
  double get severity;

  bool shouldTrigger();

  void reset() {}
}
