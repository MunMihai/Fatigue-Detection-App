import 'package:driver_monitoring/domain/entities/alert.dart';

abstract class AlertService {
  List<Alert> get alerts;
  bool isAlertActive(String type);
  bool get noActiveAlerts;

  void triggerAlert({
    required String type,
    double severity,
  });

  void stopAlert({String? type});
  void clearAlerts();
}
