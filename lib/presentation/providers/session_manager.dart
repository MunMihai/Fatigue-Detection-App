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
import 'session_timer_provider.dart';
import 'pause_provider.dart';
import '../../core/services/alert_service.dart';

class SessionManager extends ChangeNotifier {
  final SettingsProvider settingsProvider;
  final CameraProvider cameraProvider;
  final FaceDetectionService faceDetectionService;
  final SessionTimer sessionTimer;
  final PauseManager pauseManager;
  final AlertService alertService;

  final int _faceDetectionTimeoutSec = 61;

  AppState _appState = AppState.idle;
  AppState get appState => _appState;

  SessionReport? _currentSession;
  Timer? _faceDetectionTimer;
  int _breaksCount = 0;

  VoidCallback? onSessionTimeout;
  ValueChanged<int>? onTimeRemainingNotification;
  ValueChanged<double>? onNewAlert;
  VoidCallback? onSessionStarted;
  VoidCallback? onSessionStopped;

  bool _hasTriggeredTimeout = false;
  bool _notifiedThirtyMinutes = false;
  bool _notifiedFifteenMinutes = false;

  SessionManager({
    required this.settingsProvider,
    required this.cameraProvider,
    required this.faceDetectionService,
    required this.sessionTimer,
    required this.pauseManager,
    required this.alertService,
  });

  bool get isIdle => _appState == AppState.idle;
  bool get isActive => _appState == AppState.active;
  bool get isPaused => _appState == AppState.paused;
  bool get stopping => _appState == AppState.stopping;
  int get breaksCount => _breaksCount;
  SessionReport? get currentSession => _currentSession;

  Future<void> startMonitoring() async {
    if (!isIdle) return;

    _updateAppState(AppState.initializing);
    appLogger.i('[SessionManager] Initializing session...');

    await _setupLiveFaceMonitoring();
    _initSession();

    _startTimers();
    _updateAppState(AppState.active);

    onSessionStarted?.call();
  }

  Future<SessionReport?> stopMonitoring() async {
    if (isIdle) return null;

    _updateAppState(AppState.stopping);
    appLogger.i('[SessionManager] Stopping session...');

    _cleanupTimers();
    pauseManager.stopPause();
    alertService.stopAlert();

    final session = _finalizeSession();

    await cameraProvider.stopCamera();

    _updateAppState(AppState.idle);
    onSessionStopped?.call();

    return session;
  }

  Future<void> pauseMonitoring() async {
    if (!isActive) return;
    _updateAppState(AppState.paused);
    pauseManager.startPause();
    _breaksCount++;
  }

  Future<void> resumeMonitoring() async {
    if (!isPaused && _appState != AppState.alertness) return;
    _updateAppState(AppState.active);
    pauseManager.stopPause();
  }

  Future<void> _setupLiveFaceMonitoring() async {
    cameraProvider.updateImageCallback((inputImage) async {
      await faceDetectionService.processImage(inputImage);

      cameraProvider.updateFromFaceDetection(faceDetectionService);

      _handleAlert(
        type: AlertType.drowsiness.name,
        severity: 360,
        conditionMet: faceDetectionService.closedEyesDetected,
      );

      _handleAlert(
        type: AlertType.yawning.name,
        severity: 180,
        conditionMet: faceDetectionService.yawningDetected,
      );
    });

    await cameraProvider.initialize(CameraLensDirection.front);
  }

  void _handleAlert({
    required String type,
    required double severity,
    required bool conditionMet,
  }) {
    if (conditionMet) {
      _triggerAlert(type, severity);
    } else {
      _stopAlert(type);
    }
  }

  void _triggerAlert(String type, double severity) {
    if (!isActive || alertService.isAlertActive(type)) return;

    appLogger.w('[SessionManager] Trigger alert: $type');

    alertService.triggerAlert(type: type, severity: severity);
    onNewAlert?.call(severity);

    _updateAppState(AppState.alertness);
  }

  void _stopAlert(String type) {
    if (!alertService.isAlertActive(type)) return;

    appLogger.i('[SessionManager] Stop alert: $type');

    alertService.stopAlert(type: type);

    if (alertService.noActiveAlerts) {
      _updateAppState(AppState.active);
    }
  }

  void _onTimerTick() {
    final remaining = sessionTimer.remainingTime;

    if (!_notifiedThirtyMinutes && remaining.inMinutes == 30) {
      _notifiedThirtyMinutes = true;
      appLogger.i('[SessionManager] 30 minutes remaining');
      onTimeRemainingNotification?.call(30);
    }

    if (!_notifiedFifteenMinutes && remaining.inMinutes == 15) {
      _notifiedFifteenMinutes = true;
      appLogger.i('[SessionManager] 15 minutes remaining');
      onTimeRemainingNotification?.call(15);
    }

    if (sessionTimer.countdownFinished && settingsProvider.isCounterEnabled) {
      _handleSessionTimeout();
    }
  }

  void _handleSessionTimeout() {
    if (_hasTriggeredTimeout) return;

    _hasTriggeredTimeout = true;
    appLogger.w('[SessionManager] Timer expired. Triggering break alert.');

    alertService.triggerAlert(type: AlertType.sessionExpired.name, severity: 0);
    onSessionTimeout?.call();
  }

  void _initSession() {
    faceDetectionService.reset(settingsProvider.sessionSensitivity);

    _currentSession = SessionReport(
      id: 'session-${DateTime.now().microsecondsSinceEpoch}',
      timestamp: DateTime.now(),
      durationMinutes: 0,
      highestSeverityScore: 0.0,
      retentionMonths: settingsProvider.retentionMonths,
      alerts: [],
    );

    _breaksCount = 0;
    _hasTriggeredTimeout = false;
    _notifiedThirtyMinutes = false;
    _notifiedFifteenMinutes = false;

    alertService.clearAlerts();
    pauseManager.reset();
  }

  SessionReport? _finalizeSession() {
    final session = _currentSession?.copyWith(
      durationMinutes: sessionTimer.elapsedTime.inMinutes,
      alerts: alertService.alerts,
    );

    _currentSession = null;
    sessionTimer.reset();
    return session;
  }

  void _startTimers() {
    sessionTimer.start(
      countdownDuration: Duration(
        hours: settingsProvider.savedHours,
        minutes: settingsProvider.savedMinutes,
      ),
    );
    sessionTimer.addListener(_onTimerTick);

    _faceDetectionTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      final elapsed =
          DateTime.now().difference(faceDetectionService.lastFaceDetectedTime);

      if (elapsed.inSeconds >= _faceDetectionTimeoutSec && !isPaused) {
        appLogger.w(
            '[SessionManager] Face not detected for $elapsed. Stopping session.');
        stopMonitoring();
      } else {
        appLogger.i(
            '[SessionManager] Last face detected ${elapsed.inSeconds} seconds ago.');
      }
    });
  }

  void _cleanupTimers() {
    _faceDetectionTimer?.cancel();
    _faceDetectionTimer = null;
    sessionTimer.removeListener(_onTimerTick);
  }

  void _updateAppState(AppState state) {
    _appState = state;
    notifyListeners();
  }

  @override
  void dispose() {
    _cleanupTimers();
    sessionTimer.removeListener(_onTimerTick);
    super.dispose();
  }
}
