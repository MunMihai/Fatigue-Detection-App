import 'dart:async';
import 'package:driver_monitoring/core/enum/app_state.dart';
import 'package:driver_monitoring/domain/repositories/camera_repository.dart';
import 'package:flutter/foundation.dart';

import 'package:driver_monitoring/core/utils/app_logger.dart';
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
  final CameraRepository cameraRepository; // ADD repo field

  AppState _appState = AppState.idle;
  AppState get appState => _appState;

  SessionReport? _currentSession;
  int _breaksCount = 0;

  SessionManager({
    required this.settingsProvider,
    required this.sessionTimer,
    required this.pauseManager,
    required this.alertManager,
    required this.cameraRepository, // ADD repo in constructor
  });

  bool get isIdle => _appState == AppState.idle;
  bool get isActive => _appState == AppState.active;
  bool get isPaused => _appState == AppState.paused;

  int get breaksCount => _breaksCount;
  SessionReport? get currentSession => _currentSession;

  Future<void> startMonitoring() async {
    if (!isIdle) return;

    appLogger.i('[SessionManager] Moving to ACTIVE state...');
    _appState = AppState.active;

    /// 🟦 Inițializează camera
    //await cameraRepository.initializeCamera();
    //appLogger.i('[SessionManager] Camera initialized');

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

  Future<SessionReport?> stopMonitoring() async {
    if (!isActive && !isPaused) return null;

    appLogger.i('[SessionManager] Moving to IDLE state...');
    _appState = AppState.idle;

    /// 🟦 Dezactivezi camera
    //await cameraRepository.disposeCamera();
    //appLogger.i('[SessionManager] Camera disposed');

    sessionTimer.stop();
    pauseManager.stopPause();

    final session = _currentSession?.copyWith(
      durationMinutes: sessionTimer.elapsedTime.inMinutes,
      alerts: alertManager.alerts,
      averageSeverity: alertManager.averageSeverity,
    );

    _currentSession = null;
    sessionTimer.reset();

    notifyListeners();
    return session;
  }

  Future<void> pauseMonitoring() async {
    if (!isActive) return;

    appLogger.i('[SessionManager] Moving to PAUSED state...');
    _appState = AppState.paused;

    pauseManager.startPause();
    _breaksCount++;

    notifyListeners();
  }

  Future<void> resumeMonitoring() async {
    if (!isPaused) return;

    appLogger.i('[SessionManager] Resuming from PAUSED to ACTIVE...');
    _appState = AppState.active;

    pauseManager.stopPause();

    notifyListeners();
  }

  void addAlert(Alert alert) {
    alertManager.addAlert(alert);
    notifyListeners();
  }

  void _onTimerTick() {
    if (sessionTimer.countdownFinished) {
      _handleCountdownFinished();
    }

    notifyListeners();
  }

  void _handleCountdownFinished() {
    appLogger
        .w('[SessionManager] Session timer expired! Triggering break alert.');

    addAlert(Alert(
      id: 'timeout-${DateTime.now().microsecondsSinceEpoch}',
      timestamp: DateTime.now(),
      severity: 0.0,
      type: 'Session timer expired! Please take a break!',
    ));
  }

  @override
  void dispose() {
    sessionTimer.removeListener(_onTimerTick);
    super.dispose();
  }
}
