import 'dart:async';
import 'package:camera/camera.dart';
import 'package:driver_monitoring/core/enum/alert_type.dart';
import 'package:driver_monitoring/core/enum/app_state.dart';
import 'package:driver_monitoring/core/services/face_detection_service.dart';
import 'package:driver_monitoring/presentation/providers/camera_provider.dart';
import 'package:flutter/foundation.dart';

import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/domain/entities/session_report.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';
import 'session_timer.dart';
import 'pause_manager.dart';
import 'alert_manager.dart';

class SessionManager extends ChangeNotifier {
  final SettingsProvider settingsProvider;
  final CameraProvider cameraProvider;
  final FaceDetectionService faceDetectionService;
  final SessionTimer sessionTimer;
  final PauseManager pauseManager;
  final AlertManager alertManager;

  final int _faceDetectionTime = 60;

  AppState _appState = AppState.idle;
  AppState get appState => _appState;

  SessionReport? _currentSession;
  int _breaksCount = 0;
  Timer? _faceDetectionTimeoutTimer;

  VoidCallback? onSessionTimeout;
  ValueChanged<int>? onTimeRemainingNotification;


  bool _hasTriggeredTimeout = false;
  bool _notifiedThirtyMinutes = false;
  bool _notifiedFifteenMinutes = false;

  SessionManager({
    required this.settingsProvider,
    required this.cameraProvider,
    required this.faceDetectionService,
    required this.sessionTimer,
    required this.pauseManager,
    required this.alertManager,
  });

  bool get isIdle => _appState == AppState.idle;
  bool get isActive => _appState == AppState.active;
  bool get isPaused => _appState == AppState.paused;
  bool get stopping => _appState == AppState.stopping;
  bool get initializing => _appState == AppState.initializing;
  bool get isAlerting => _appState == AppState.alertness;

  int get breaksCount => _breaksCount;
  SessionReport? get currentSession => _currentSession;

  Future<void> startMonitoring() async {
    if (!isIdle) return;
    appLogger.i('[SessionManager] Initializing state...');
    _appState = AppState.initializing;
    notifyListeners();

    await _initializeCamera();

    faceDetectionService.reset(settingsProvider.sessionSensitivity);

    _currentSession = SessionReport(
      id: 'session-${DateTime.now().microsecondsSinceEpoch}',
      timestamp: DateTime.now(),
      durationMinutes: 0,
      averageSeverity: 0.0,
      camera: _cameraLensDirectionToString(
          cameraProvider.controller?.description.lensDirection),
      retentionMonths: settingsProvider.retentionMonths,
      alerts: [],
    );

    _breaksCount = 0;
    alertManager.clearAlerts();
    pauseManager.reset();
    _hasTriggeredTimeout = false;
    _notifiedThirtyMinutes = false;
    _notifiedFifteenMinutes = false;

    sessionTimer.start(
      countdownDuration: Duration(
        hours: settingsProvider.savedHours,
        minutes: settingsProvider.savedMinutes,
      ),
    );

    sessionTimer.addListener(_onTimerTick);

    appLogger.i('[SessionManager] Moving to ACTIVE state...');
    _appState = AppState.active;

    _faceDetectionTimeoutTimer =
        Timer.periodic(const Duration(seconds: 5), (_) {
      final elapsedSinceLastFace =
          DateTime.now().difference(faceDetectionService.lastFaceDetectedTime);

      if (elapsedSinceLastFace.inSeconds >= _faceDetectionTime && !isPaused) {
        appLogger.w(
            '[SessionManager] No face detected for ${elapsedSinceLastFace.inSeconds} seconds. Stopping session...');

        stopMonitoring();
      } else {
        appLogger.i(
            '[SessionManager] Last face detected ${elapsedSinceLastFace.inSeconds} seconds ago.');
      }
    });

    notifyListeners();
  }

  Future<SessionReport?> stopMonitoring() async {
    if (!isActive && !isPaused) return null;

    appLogger.i('[SessionManager] Moving to STOPPING state...');
    _appState = AppState.stopping;
    notifyListeners();

    /// ✅ Oprești timerul de verificare a faței
    _faceDetectionTimeoutTimer?.cancel();
    _faceDetectionTimeoutTimer = null;

    faceDetectionService.reset(settingsProvider.sessionSensitivity);

    sessionTimer.removeListener(_onTimerTick);
    pauseManager.stopPause();
    alertManager.stopAlert();

    final session = _currentSession?.copyWith(
      durationMinutes: sessionTimer.elapsedTime.inMinutes,
      alerts: alertManager.alerts,
      averageSeverity: alertManager.averageSeverity,
    );

    _currentSession = null;
    sessionTimer.reset();
    await cameraProvider.stopCamera();

    appLogger.i('[SessionManager] Moving to IDLE state...');
    _appState = AppState.idle;

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
    if (!isPaused && !isAlerting) return;

    appLogger.i('[SessionManager] Resuming to ACTIVE...');
    _appState = AppState.active;

    pauseManager.stopPause();
    notifyListeners();
  }

  Future<void> _initializeCamera() async {
    cameraProvider.updateImageCallback((inputImage) {
      faceDetectionService.processImage(inputImage);

      if (faceDetectionService.closedEyesDetected) {
        _triggerDrowsinessAlert();
      } else {
        _stopDrowsinessAlert();
      }
    });

    await cameraProvider.initialize(CameraLensDirection.front);
  }

  void _triggerDrowsinessAlert() {
    if (_appState == AppState.active) {
      appLogger.w('[SessionManager] Drowsiness detected, triggering alert!');

      alertManager.triggerAlert(
        type: AlertType.drowsiness.name,
        severity: 1,
      );

      _appState = AppState.alertness;
      notifyListeners();
    }
  }

  void _stopDrowsinessAlert() {
    if (_appState == AppState.alertness) {
      appLogger.i('[SessionManager] Eyes opened, stopping alert.');

      alertManager.stopAlert(type: AlertType.drowsiness.name);

      _appState = AppState.active;
      notifyListeners();
    }
  }

  void _onTimerTick() {
    final countdownRemaining = sessionTimer.remainingTime;

    if (!_notifiedFifteenMinutes && countdownRemaining.inMinutes == 15) {
      if (!_notifiedThirtyMinutes && countdownRemaining.inMinutes == 30) {
        _notifiedThirtyMinutes = true;
        appLogger
            .i('[SessionManager]30 minutes remaining notification triggered.');
        onTimeRemainingNotification?.call(30);
      } else {
        _notifiedFifteenMinutes = true;
        appLogger
            .i('[SessionManager]15 minutes remaining notification triggered.');
        onTimeRemainingNotification?.call(15);
      }
    }
    // Countdown finished
    if (sessionTimer.countdownFinished && settingsProvider.isCounterEnabled) {
      _handleCountdownFinished();
    }

    notifyListeners();
  }

  void _handleCountdownFinished() {
    if (_hasTriggeredTimeout) return;

    _hasTriggeredTimeout = true;
    appLogger
        .w('[SessionManager] Session timer expired! Triggering break alert.');

    alertManager.triggerAlert(type: AlertType.sessionExpired.name, severity: 0);

    onSessionTimeout?.call();
  }

  String _cameraLensDirectionToString(CameraLensDirection? direction) {
    switch (direction) {
      case CameraLensDirection.front:
        return 'Front Camera';
      case CameraLensDirection.back:
        return 'MainPhone Camera';
      case CameraLensDirection.external:
        return 'External Camera';
      default:
        return 'Unknown Camera';
    }
  }

  @override
  void dispose() {
    _faceDetectionTimeoutTimer?.cancel();
    sessionTimer.removeListener(_onTimerTick);
    super.dispose();
  }
}
