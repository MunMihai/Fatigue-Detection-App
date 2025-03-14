import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:driver_monitoring/domain/entities/session_report.dart';
import 'package:driver_monitoring/domain/entities/alert.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';

class SessionManager extends ChangeNotifier {
  final SettingsProvider settingsProvider;

  SessionReport? _currentSession;
  final List<Alert> _alerts = [];

  DateTime? _startTime;
  DateTime? _pauseStart;
  Duration _totalPauseDuration = Duration.zero;

  bool _isPaused = false;
  int _breaksCount = 0;

  Timer? _timer;
  Timer? _pauseTimer;

  SessionManager({required this.settingsProvider});

  SessionReport? get currentSession => _currentSession;
  List<Alert> get alerts => List.unmodifiable(_alerts);

  bool get isActive => _currentSession != null;
  bool get isPaused => _isPaused;

  double get score => _calculateAverageSeverity();
Duration get breakTime {
  if (_pauseStart != null && _isPaused) {
    final pauseDuration = DateTime.now().difference(_pauseStart!);
    return _totalPauseDuration + pauseDuration;
  } else {
    return _totalPauseDuration;
  }
}  int get breaksCount => _breaksCount;

  Duration get elapsedTime {
    if (_startTime == null) return Duration.zero;
    final now = DateTime.now();

    final baseDuration = now.difference(_startTime!);

    final totalDuration = baseDuration + _totalPauseDuration;

    return totalDuration;
  }

  void startSession() {
    final now = DateTime.now();

    _currentSession = SessionReport(
      id: 'session-${now.microsecondsSinceEpoch}',
      timestamp: now,
      durationMinutes: 0,
      averageSeverity: 0.0,
      camera: 'FrontCam',
      retentionMonths: settingsProvider.retentionMonths,
      alerts: [],
    );

    _alerts.clear();
    _startTime = now;
    _pauseStart = null;
    _totalPauseDuration = Duration.zero;
    _breaksCount = 0;
    _isPaused = false;

    _startTimer();  

    notifyListeners();
  }

  SessionReport? stopSession() {
    if (_currentSession == null) return null;

    if (_isPaused) stopPause();

    final duration = elapsedTime.inMinutes;

    final finishedSession = _currentSession!.copyWith(
      durationMinutes: duration,
      alerts: List.unmodifiable(_alerts),
      averageSeverity: _calculateAverageSeverity(),
    );

    _currentSession = null;
    _alerts.clear();
    _startTime = null;
    _pauseStart = null;
    _totalPauseDuration = Duration.zero;
    _breaksCount = 0;
    _isPaused = false;

    _stopTimer();  

    notifyListeners();

    return finishedSession;
  }

  void startPause() {
    if (!_isPaused && _currentSession != null) {
      _pauseStart = DateTime.now();
      _isPaused = true;
      _breaksCount++;

      _startPauseTimer();  

      notifyListeners();
    }
  }

  void stopPause() {
    if (_isPaused && _pauseStart != null) {
      final pauseDuration = DateTime.now().difference(_pauseStart!);
      _totalPauseDuration += pauseDuration;

      _pauseStart = null;
      _isPaused = false;

      _stopPauseTimer();  

      notifyListeners();
    }
  }

  void addAlert(Alert alert) {
    if (_currentSession == null || _isPaused) return; // nu adăugăm alerte dacă e pauză

    _alerts.add(alert);

    _currentSession = _currentSession!.copyWith(
      alerts: List.unmodifiable(_alerts),
      averageSeverity: _calculateAverageSeverity(),
    );

    notifyListeners();
  }

  void resetSession() {
    _currentSession = null;
    _alerts.clear();
    _startTime = null;
    _pauseStart = null;
    _totalPauseDuration = Duration.zero;
    _breaksCount = 0;
    _isPaused = false;

    _stopTimer();

    notifyListeners();
  }

  double _calculateAverageSeverity() {
    if (_alerts.isEmpty) return 0.0;
    final total = _alerts.fold(0.0, (sum, alert) => sum + alert.severity);
    return total / _alerts.length;
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) {
      notifyListeners();  
    });
  }

  // Oprește timer-ul
  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  void _startPauseTimer() {
    _pauseTimer = Timer.periodic(Duration(seconds: 1), (_) {
      notifyListeners();  // Actualizează UI-ul și timp de pauză
    });
  }

  void _stopPauseTimer() {
    _pauseTimer?.cancel();
    _pauseTimer = null;
  }
}
