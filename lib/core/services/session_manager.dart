import 'package:flutter/foundation.dart';
import 'package:driver_monitoring/domain/entities/session_report.dart';
import 'package:driver_monitoring/domain/entities/alert.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';
import 'session_timer.dart';
import 'pause_manager.dart';
import 'alert_manager.dart';

class SessionManager extends ChangeNotifier {
  final SettingsProvider settingsProvider;
  final SessionTimer sessionTimer;
  final PauseManager pauseManager;
  final AlertManager alertManager;

  SessionReport? _currentSession;
  int _breaksCount = 0;

  SessionManager({
    required this.settingsProvider,
    required this.sessionTimer,
    required this.pauseManager,
    required this.alertManager,
  });

  // Getters
  bool get isActive => _currentSession != null;
  int get breaksCount => _breaksCount;

  SessionReport? get currentSession => _currentSession;

  void startSession() {
    _currentSession = SessionReport(
      id: 'session-${DateTime.now().microsecondsSinceEpoch}',
      timestamp: DateTime.now(),
      durationMinutes: 0,
      averageSeverity: 0.0,
      camera: 'FrontCam',
      retentionMonths: settingsProvider.retentionMonths,
      alerts: [],
    );

    _breaksCount = 0;
    alertManager.clearAlerts();
    pauseManager.reset();

    sessionTimer.start(
      countdownDuration: Duration(
        hours: settingsProvider.savedHours,
        minutes: settingsProvider.savedMinutes,
      ),
    );

    sessionTimer.addListener(_onTimerTick);

    notifyListeners();
  }

SessionReport? stopSession() {
    if (!isActive) return null;

    sessionTimer.stop();
    pauseManager.stopPause();

    final session = _currentSession!.copyWith(
      durationMinutes: sessionTimer.elapsedTime.inMinutes,
      alerts: alertManager.alerts,
      averageSeverity: alertManager.averageSeverity,
    );

    _currentSession = null;
    sessionTimer.reset();

    notifyListeners();

    return session;
  }

  void startPause() {
    pauseManager.startPause();
    _breaksCount++;
    notifyListeners();
  }

  void stopPause() {
    pauseManager.stopPause();
    notifyListeners();
  }

  void _onTimerTick() {
    if (sessionTimer.countdownFinished) {
      _handleCountdownFinished();
    }
    notifyListeners();
  }

  void addAlert(Alert alert) {
    alertManager.addAlert(alert);
    notifyListeners();
  }

  void _handleCountdownFinished() {
    addAlert(Alert(
      id: 'timeout-${DateTime.now().microsecondsSinceEpoch}',
      timestamp: DateTime.now(),
      severity: 1.0,
      type: 'Session timer expired! Please take a break!',
    ));

    // Optional: stopSession();
  }
}
