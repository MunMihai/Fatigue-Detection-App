import 'dart:async';
import 'package:camera/camera.dart';
import 'package:driver_monitoring/domain/enum/alert_type.dart';
import 'package:driver_monitoring/domain/enum/app_state.dart';
import 'package:driver_monitoring/domain/services/alert_service.dart';
import 'package:driver_monitoring/domain/services/face_detection_service.dart';
import 'package:driver_monitoring/domain/strategies/alert_strategy.dart';
import 'package:driver_monitoring/domain/strategies/drowsiness_alert.dart';
import 'package:driver_monitoring/domain/strategies/yawning_alert.dart';
import 'package:driver_monitoring/presentation/providers/camera_provider.dart';
import 'package:flutter/foundation.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/domain/entities/session_report.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';
import 'package:google_mlkit_commons/google_mlkit_commons.dart';
import 'session_timer_provider.dart';
import 'pause_provider.dart';

class SessionManager extends ChangeNotifier {
  final SettingsProvider settingsProvider;
  final CameraProvider cameraProvider;
  late FaceDetectionService faceDetectionService;
  final SessionTimer sessionTimer;
  final PauseManager pauseManager;
  final AlertService alertService;
  late List<AlertStrategy> _alertStrategies;

  final int _faceDetectionTimeoutSec = 61;
  final List<DateTime> _yawnTimestamps = [];

  AppState _appState = AppState.idle;
  AppState get appState => _appState;

  SessionReport? _currentSession;
  Timer? _faceDetectionTimer;
  int _breaksCount = 0;

  Future<void> Function()? onSessionTimeout;
  ValueChanged<int>? onTimeRemainingNotification;
  ValueChanged<double>? onNewAlert;
  VoidCallback? onSessionStarted;
  VoidCallback? onSessionStopped;

  bool _hasTriggeredTimeout = false;
  bool _notifiedThirtyMinutes = false;
  bool _notifiedFifteenMinutes = false;
  StreamSubscription<InputImage>? _imageSubscription;

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

    _imageSubscription?.cancel();
    _imageSubscription = null;

    _cleanupTimers();
    pauseManager.stopPause();
    alertService.stopAlert();

    final session = _finalizeSession();

    _yawnTimestamps.clear();
    for (final strategy in _alertStrategies) {
      strategy.reset();
    }

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
    await cameraProvider.initialize(CameraLensDirection.front);

    _alertStrategies = [
      DrowsinessAlert(faceDetectionService),
      YawningAlert(faceDetectionService),

    ];

    _imageSubscription = cameraProvider.imageStream?.listen((inputImage) async {
      await faceDetectionService.processImage(inputImage);

      cameraProvider.updateFromDetection(
        paint: faceDetectionService.customPaint,
        text: faceDetectionService.detectionText,
      );

      for (final strategy in _alertStrategies) {
        _handleAlert(
          type: strategy.type.name,
          severity: strategy.severity,
          conditionMet: strategy.shouldTrigger(),
        );
      }
    });
  }

  void updateFaceService(FaceDetectionService newService) {
    faceDetectionService = newService;
    appLogger.i('[SessionManager] FaceDetectionService updated');
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

    if (!_notifiedFifteenMinutes && remaining.inMinutes == 10) {
      _notifiedFifteenMinutes = true;
      appLogger.i('[SessionManager] 10 minutes remaining');
      onTimeRemainingNotification?.call(10);
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
    _imageSubscription?.cancel();
    _cleanupTimers();
    sessionTimer.removeListener(_onTimerTick);
    super.dispose();
  }
}
