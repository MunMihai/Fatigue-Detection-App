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

  AppState _appState = AppState.idle;
  AppState get appState => _appState;

  SessionReport? _currentSession;
  int _breaksCount = 0;

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

    sessionTimer.start(
      countdownDuration: Duration(
        hours: settingsProvider.savedHours,
        minutes: settingsProvider.savedMinutes,
      ),
    );

    sessionTimer.addListener(_onTimerTick);
    appLogger.i('[SessionManager] Moving to ACTIVE state...');
    _appState = AppState.active;

    notifyListeners();
  }

  Future<SessionReport?> stopMonitoring() async {
    if (!isActive && !isPaused) return null;

    appLogger.i('[SessionManager] Moving to STOPPING state...');
    _appState = AppState.stopping;
    notifyListeners();


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
    if (!isPaused) return;

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
        type: AlertType.drowsiness.description,
        severity: 1,
      );

      _appState = AppState.alertness;
      notifyListeners();
    }
  }

  void _stopDrowsinessAlert() {
    if (_appState == AppState.alertness) {
      appLogger.i('[SessionManager] Eyes opened, stopping alert.');

      alertManager.stopAlert();

      _appState = AppState.active;
      notifyListeners();
    }
  }

  void _onTimerTick() {
    if (sessionTimer.countdownFinished && settingsProvider.isCounterEnabled) {
      _handleCountdownFinished();
    }

    notifyListeners();
  }

  void _handleCountdownFinished() {
    appLogger
        .w('[SessionManager] Session timer expired! Triggering break alert.');

    alertManager.triggerAlert(
        type: AlertType.sessionExpired.description, severity: 0);
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
    sessionTimer.removeListener(_onTimerTick);
    super.dispose();
  }
}
