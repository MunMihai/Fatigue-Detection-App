import 'alert_strategy.dart';
import 'package:driver_monitoring/domain/enum/alert_type.dart';
import 'package:driver_monitoring/presentation/providers/session_timer_provider.dart';

class SessionExpiredAlert implements AlertStrategy {
  final SessionTimer sessionTimer;
  final bool isCounterEnabled;
  final void Function() onTimeout;

  bool _hasTriggered = false;

  SessionExpiredAlert({
    required this.sessionTimer,
    required this.isCounterEnabled,
    required this.onTimeout,
  });

  @override
  AlertType get type => AlertType.sessionExpired;

  @override
  double get severity => 0;

  @override
  bool shouldTrigger() {
    if (_hasTriggered) return false;

    final expired = sessionTimer.countdownFinished && isCounterEnabled;
    if (expired) {
      _hasTriggered = true;
      onTimeout();
    }
    return expired;
  }

  @override
  void reset() {
    _hasTriggered = false;
  }
}
