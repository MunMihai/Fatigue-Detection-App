import 'package:driver_monitoring/domain/entities/alert.dart';
import 'package:driver_monitoring/domain/services/alert_service.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/domain/services/audio_service.dart';

class AlertServiceImpl implements AlertService {
  final List<Alert> _alerts = [];
  final Set<String> _activeAlertTypes = {};
  final AudioService _audioService;

  AlertServiceImpl({required AudioService audioService})
      : _audioService = audioService;

  @override
  List<Alert> get alerts => List.unmodifiable(_alerts);

  @override
  bool isAlertActive(String type) => _activeAlertTypes.contains(type);

  @override
  bool get noActiveAlerts => _activeAlertTypes.isEmpty;

  @override
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

  @override
  void stopAlert({String? type}) {
    if (type == null) {
      if (noActiveAlerts) {
        appLogger.i('ℹ️ No active alerts to stop.');
        return;
      }

      appLogger.i('🛑 Stopping ALL alerts: $_activeAlertTypes');
      clearAlerts();
    } else {
      final wasRemoved = _activeAlertTypes.remove(type);

      if (!wasRemoved) {
        appLogger.w('⚠️ Tried to stop alert "$type", but it was not active.');
        _audioService.stopAudio();
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
  }

  @override
  void clearAlerts() {
    _alerts.clear();
    _activeAlertTypes.clear();
    _audioService.stopAudio();
    appLogger.i('🗑️ All alerts cleared.');
  }

  void _addAlert(Alert alert) {
    _alerts.add(alert);
    _activeAlertTypes.add(alert.type);

    appLogger.i('➕ Added alert: ${alert.type} | Severity: ${alert.severity}');
  }
}
