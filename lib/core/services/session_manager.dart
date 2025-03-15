import 'dart:async';
import 'package:driver_monitoring/core/services/camera_manager.dart';
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
  final CameraManager cameraManager;

  SessionReport? _currentSession;
  int _breaksCount = 0;

  StreamSubscription? _frameSubscription;

  SessionManager({
    required this.settingsProvider,
    required this.sessionTimer,
    required this.pauseManager,
    required this.alertManager,
    required this.cameraManager,
  });

  bool get isActive => _currentSession != null;
  int get breaksCount => _breaksCount;
  SessionReport? get currentSession => _currentSession;

  Future<void> startSession() async {
    appLogger.i('[SessionManager] Starting new session...');

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

    try {
      await cameraManager.startCapturing();
      await _listenToFrames();
      appLogger.i('[SessionManager] Camera capturing started.');
    } catch (e, stackTrace) {
      appLogger.e('[SessionManager] Failed to start camera capturing.',
          error: e, stackTrace: stackTrace);
      stopSession();
      return;
    }

    notifyListeners();
  }

  Future<SessionReport?> stopSession() async {
    if (!isActive) return null;

    appLogger.i('[SessionManager] Stopping session...');

    sessionTimer.stop();
    pauseManager.stopPause();

    try {
      await cameraManager.stopCapturing();
      await _frameSubscription?.cancel();
      _frameSubscription = null;

      appLogger
          .i('[SessionManager] Camera capturing and frame listening stopped.');
    } catch (e, stackTrace) {
      appLogger.e('[SessionManager] Failed to stop camera capturing.',
          error: e, stackTrace: stackTrace);
    }

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

  void startPause() async {
    appLogger.i('[SessionManager] Pausing session...');

    pauseManager.startPause();
    _breaksCount++;

    // ✅ Oprești ascultarea la frame-uri
    await _frameSubscription?.cancel();
    _frameSubscription = null;

    // (Opțional) Oprești complet stream-ul video
    await cameraManager.stopCapturing();

    notifyListeners();
  }

  void stopPause() async {
    appLogger.i('[SessionManager] Resuming session...');

    pauseManager.stopPause();

    // ✅ Repornești stream-ul video
    await cameraManager.startCapturing();

    // ✅ Reîncepi ascultarea la frame-uri
    await _listenToFrames();

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
    appLogger
        .w('[SessionManager] Session timer expired! Triggering break alert.');

    addAlert(Alert(
      id: 'timeout-${DateTime.now().microsecondsSinceEpoch}',
      timestamp: DateTime.now(),
      severity: 1.0,
      type: 'Session timer expired! Please take a break!',
    ));
  }

  Future<void> _listenToFrames() async {
    appLogger.i('[SessionManager] Subscribing to frame stream...');

    await _frameSubscription?.cancel();

    _frameSubscription = cameraManager.frameStream.listen(
      (frame) {
        appLogger.t('[SessionManager] New frame received');

        // TODO: Aici faci analiza pe frame, scoruri etc.
        // _analyzeFrame(frame);
      },
      onError: (error, stack) {
        appLogger.e('[SessionManager] Error in frame stream',
            error: error, stackTrace: stack);
      },
      cancelOnError: false,
    );
  }

  @override
  void dispose() {
    _frameSubscription?.cancel();
    sessionTimer.removeListener(_onTimerTick);
    super.dispose();
  }
}

// TODO: Dacă vrei să adaugi o analiză pe frame:
// void _analyzeFrame(CameraImage frame) {
//   appLogger.t('[SessionManager] Processing frame...');
//   // Ex: AI processing, detect oboseală etc.
// }
