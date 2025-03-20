import 'package:driver_monitoring/core/services/audio_alert_service.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/domain/entities/alert.dart';
import 'package:flutter/material.dart';

class AlertManager extends ChangeNotifier {
  final List<Alert> _alerts = [];
  final Set<String> _activeAlertTypes = {};

  final AudioAlertService _audioService = AudioAlertService();

  List<Alert> get alerts => List.unmodifiable(_alerts);
  double get averageSeverity => _calculateAverageSeverity();

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
    appLogger.i(
        '🛑 Stopping alert${type != null ? ' of type: $type' : ' (all alerts)'}');

    // Dacă oprești doar un anumit tip de alertă
    if (type != null) {
      final wasRemoved = _activeAlertTypes.remove(type);

      if (wasRemoved) {
        appLogger.i('✅ Alert of type "$type" stopped.');
      } else {
        appLogger.w('⚠️ Tried to stop alert "$type", but it was not active.');
      }
    } else {
      _activeAlertTypes.clear();
      appLogger.i('✅ All alerts stopped.');
    }

    // Dacă nu mai există alerte active, oprește sunetul.
    if (_activeAlertTypes.isEmpty) {
      appLogger.i('🛑 No more active alerts. Stopping audio.');
      _audioService.stopAlert();
    } else {
      appLogger.i('ℹ️ Remaining active alerts: $_activeAlertTypes');
    }
  }

  double _calculateAverageSeverity() {
    if (_alerts.isEmpty) return 0.0;
    final total = _alerts.fold(0.0, (sum, alert) => sum + alert.severity);
    return total / _alerts.length;
  }

  @override
  void dispose() {
    _audioService.stopAlert();
    _audioService.dispose();
    super.dispose();
  }
}
