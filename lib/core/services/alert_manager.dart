import 'package:driver_monitoring/core/services/audio_alert_service.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/domain/entities/alert.dart';
import 'package:flutter/material.dart';

class AlertManager extends ChangeNotifier {
  final List<Alert> _alerts = [];
  final Set<String> _activeAlertTypes = {};

  final AudioAlertService _audioService = AudioAlertService();


  List<Alert> get alerts => List.unmodifiable(_alerts);
  bool isAlertActive(String type) => _activeAlertTypes.contains(type);
  bool get noActiveAlerts => _activeAlertTypes.isEmpty;


  void addAlert(Alert alert) {
    _alerts.add(alert);
    _activeAlertTypes.add(alert.type);
    notifyListeners();
  }

  void clearAlerts() {
    _alerts.clear();
    _activeAlertTypes.clear();
    notifyListeners();
  }

  void triggerAlert({
    required String type,
    double severity = 0.0,
  }) {
    if (_activeAlertTypes.contains(type)) {
      appLogger.d('⚠️ Alert already active: $type');
      return;
    }

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

  void stopAlert({
  String? type,
}) {
  if (type == null) {
    if (_activeAlertTypes.isEmpty) {
      appLogger.i('ℹ️ No active alerts to stop.');
    } else {
      appLogger.i('🛑 Stopping ALL alerts: $_activeAlertTypes');
      _activeAlertTypes.clear();
    }
  } else {
    final wasRemoved = _activeAlertTypes.remove(type);

    if (wasRemoved) {
      appLogger.i('✅ Alert of type "$type" stopped.');
    } else {
      appLogger.w('⚠️ Tried to stop alert "$type", but it was not active.');
    }
  }

  if (_activeAlertTypes.isEmpty) {
    appLogger.i('🛑 No more active alerts. Stopping audio.');
    _audioService.stopAlert();
  } else {
    appLogger.i('ℹ️ Remaining active alerts: $_activeAlertTypes');
  }
}



  @override
  void dispose() {
    _audioService.stopAlert();
    _audioService.dispose();
    super.dispose();
  }
}
