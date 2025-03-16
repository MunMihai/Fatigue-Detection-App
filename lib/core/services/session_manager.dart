import 'dart:async';
import 'package:driver_monitoring/core/services/analysis/frame_processor.dart';
import 'package:flutter/foundation.dart';
import 'package:driver_monitoring/core/services/camera_manager.dart';
import 'package:driver_monitoring/core/services/session_timer.dart';
import 'package:driver_monitoring/core/services/pause_manager.dart';
import 'package:driver_monitoring/core/services/alert_manager.dart';
import 'package:driver_monitoring/core/services/analysis/frame_analyzer.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/domain/entities/session_report.dart';
import 'package:driver_monitoring/domain/entities/alert.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';

class SessionManager extends ChangeNotifier {
  final SettingsProvider settingsProvider;
  final SessionTimer sessionTimer;
  final PauseManager pauseManager;
  final AlertManager alertManager;
  final CameraManager cameraManager;
  final FrameAnalyzer frameAnalyzer;

  SessionReport? _currentSession;
  int _breaksCount = 0;

  late final FrameProcessor _frameProcessor;

  SessionManager({
    required this.settingsProvider,
    required this.sessionTimer,
    required this.pauseManager,
    required this.alertManager,
    required this.cameraManager,
    required this.frameAnalyzer,
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

      _frameProcessor = FrameProcessor(
        cameraManager: cameraManager,
        frameAnalyzer: frameAnalyzer,
        onAlertDetected: addAlert,
      );

      await _frameProcessor.start();
      appLogger.i('[SessionManager] Camera capturing and frame processing started.');
    } catch (e, stackTrace) {
      appLogger.e('[SessionManager] Failed to start session.', error: e, stackTrace: stackTrace);
      await stopSession();
    }

    notifyListeners();
  }

  Future<SessionReport?> stopSession() async {
    if (!isActive) return null;

    appLogger.i('[SessionManager] Stopping session...');

    sessionTimer.stop();
    pauseManager.stopPause();

    try {
      await _frameProcessor.stop();
      await cameraManager.stopCapturing();
      appLogger.i('[SessionManager] Camera capturing and frame processing stopped.');
    } catch (e, stackTrace) {
      appLogger.e('[SessionManager] Failed to stop session.', error: e, stackTrace: stackTrace);
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

  Future<void> pauseSession() async {
    appLogger.i('[SessionManager] Pausing session...');

    pauseManager.startPause();
    _breaksCount++;

    await _frameProcessor.stop();
    await cameraManager.stopCapturing();

    notifyListeners();
  }

  Future<void> resumeSession() async {
    appLogger.i('[SessionManager] Resuming session...');

    pauseManager.stopPause();

    await cameraManager.startCapturing();
    await _frameProcessor.start();

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
    appLogger.w('[SessionManager] Session timer expired! Triggering break alert.');

    addAlert(Alert(
      id: 'timeout-${DateTime.now().microsecondsSinceEpoch}',
      timestamp: DateTime.now(),
      severity: 1.0,
      type: 'Session timer expired! Please take a break!',
    ));
  }

  @override
  void dispose() {
    _frameProcessor.stop();
    sessionTimer.removeListener(_onTimerTick);
    super.dispose();
  }
}
