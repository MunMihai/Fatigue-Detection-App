import 'package:driver_monitoring/core/services/audio_service.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/domain/entities/alert.dart';
import 'package:flutter/material.dart';

class AlertManager extends ChangeNotifier {
  final List<Alert> _alerts = [];
  final Set<String> _activeAlertTypes = {};
  final AudioService _audioService = AudioService();

  List<Alert> get alerts => List.unmodifiable(_alerts);

  bool isAlertActive(String type) => _activeAlertTypes.contains(type);

  bool get noActiveAlerts => _activeAlertTypes.isEmpty;


  void triggerAlert({
    required String type,
    double severity = 0.0,
  }) {
    if (isAlertActive(type)) {
      appLogger.d('⚠️ Alert already active: $type');
      return;
    }

    final alert = Alert(
      id: 'alert-${DateTime.now().microsecondsSinceEpoch}',
      timestamp: DateTime.now(),
      type: type,
      severity: severity,
    );

    _addAlert(alert);

    appLogger.w('🚨 Trigger alert: $type | Severity: $severity');
    _audioService.playAudio();
  }

  void stopAlert({String? type}) {
    if (type == null) {
      if (noActiveAlerts) {
        appLogger.i('ℹ️ No active alerts to stop.');
        return;
      }

      appLogger.i('🛑 Stopping ALL alerts: $_activeAlertTypes');
      _activeAlertTypes.clear();
    } else {
      final wasRemoved = _activeAlertTypes.remove(type);

      if (!wasRemoved) {
        appLogger.w('⚠️ Tried to stop alert "$type", but it was not active.');
        return;
      }

      appLogger.i('✅ Alert of type "$type" stopped.');
    }

    if (noActiveAlerts) {
      appLogger.i('🛑 No more active alerts. Stopping audio.');
      _audioService.stopAudio();
    } else {
      appLogger.i('ℹ️ Remaining active alerts: $_activeAlertTypes');
    }

    notifyListeners();
  }

  void clearAlerts() {
    _alerts.clear();
    _activeAlertTypes.clear();

    appLogger.i('🗑️ All alerts cleared.');
    notifyListeners();
  }

  
  void _addAlert(Alert alert) {
    _alerts.add(alert);
    _activeAlertTypes.add(alert.type);

    appLogger.i('➕ Added alert: ${alert.type} | Severity: ${alert.severity}');
    notifyListeners();
  }

  @override
  void dispose() {
    _audioService.stopAudio();
    _audioService.dispose();

    appLogger.i('🧹 AlertManager disposed.');
    super.dispose();
  }
}
