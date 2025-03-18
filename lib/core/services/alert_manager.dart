import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:flutter/foundation.dart';
import 'package:driver_monitoring/domain/entities/alert.dart';
import 'package:driver_monitoring/core/services/audio_alert_service.dart'; // pentru sunet

class AlertManager extends ChangeNotifier {
  final List<Alert> _alerts = [];

  final AudioAlertService _audioService = AudioAlertService();

  List<Alert> get alerts => List.unmodifiable(_alerts);

  double get averageSeverity => _calculateAverageSeverity();

  void addAlert(Alert alert) {
    _alerts.add(alert);
    notifyListeners();
  }

  void clearAlerts() {
    _alerts.clear();
    notifyListeners();
  }

 void triggerAlert({
  required String type,
  double severity = 0.0,
}) {
  final alert = Alert(
    id: 'alert-${DateTime.now().microsecondsSinceEpoch}',
    timestamp: DateTime.now(),
    type: type,
    severity: severity,
  );

  addAlert(alert);
  appLogger.w('🚨 Trigger alert: $type | Severity: $severity');

  _audioService.triggerAlert();
}

void stopAlert() {
  appLogger.i('🛑 Stopping alert');
  _audioService.stopAlert();
}


  double _calculateAverageSeverity() {
    if (_alerts.isEmpty) return 0.0;
    final total = _alerts.fold(0.0, (sum, alert) => sum + alert.severity);
    return total / _alerts.length;
  }

  @override
  void dispose() {
    _audioService.dispose();
    super.dispose();
  }
}
