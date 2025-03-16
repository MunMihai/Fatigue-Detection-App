import 'dart:async';
import 'package:camera/camera.dart';
import 'package:driver_monitoring/core/services/analysis/frame_analyzer.dart';
import 'package:driver_monitoring/core/services/camera_manager.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
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
  final FrameAnalyzer frameAnalyzer;

  SessionReport? _currentSession;
  int _breaksCount = 0;

  StreamSubscription? _frameSubscription;
  bool _isProcessingFrame = false;

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

  Future<void> startPause() async {
    appLogger.i('[SessionManager] Pausing session...');

    pauseManager.startPause();
    _breaksCount++;

    await _frameSubscription?.cancel();
    _frameSubscription = null;

    await cameraManager.stopCapturing();

    notifyListeners();
  }

  Future<void> stopPause() async {
    appLogger.i('[SessionManager] Resuming session...');

    pauseManager.stopPause();

    await cameraManager.startCapturing();
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
        _analyzeFrame(frame);
      },
      onError: (error, stack) {
        appLogger.e('[SessionManager] Error in frame stream',
            error: error, stackTrace: stack);
      },
      cancelOnError: false,
    );
  }

  Future<void> _analyzeFrame(Object frame) async {
  if (_isProcessingFrame) return;
  _isProcessingFrame = true;

  try {
    appLogger.t('[SessionManager] Processing frame...');

    if (frame is CameraImage) {
      final alert = await frameAnalyzer.analyze(frame);

      if (alert != null) {
        appLogger.w('[SessionManager] Adding alert ${alert.type}');
        addAlert(alert);
      }
    }

  } catch (e, stackTrace) {
    appLogger.e('[SessionManager] Error processing frame.', error: e, stackTrace: stackTrace);
  } finally {
    _isProcessingFrame = false;
  }
}


  @override
  void dispose() {
    _frameSubscription?.cancel();
    sessionTimer.removeListener(_onTimerTick);
    super.dispose();
  }
}
