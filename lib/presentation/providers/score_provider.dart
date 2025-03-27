import 'dart:async';
import 'package:driver_monitoring/presentation/providers/session_manager.dart';
import 'package:driver_monitoring/core/utils/adjustment_utils.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:flutter/material.dart';

class ScoreProvider with ChangeNotifier {
  final SessionManager sessionManager;

  double _cumulativeSeverity = 0.0;
  DateTime? _sessionStartTime;
  double _score = 0.0;
  double _highestScore = 0.0;

  Timer? _timer;

  double get score => _score.clamp(0.0, 1.0);
  double get highestScore => _highestScore.clamp(0.0, 1.0);

  ScoreProvider(this.sessionManager) {
    sessionManager.onSessionStarted = () {
      reset();
      start();
    };
    sessionManager.onSessionStopped = stop;
    sessionManager.onNewAlert = onNewAlert;
  }

  void start() {
    if (_timer != null) return;

    appLogger.i("[ScoreProvider] Starting timer...");
    _sessionStartTime = DateTime.now();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateScore());
  }

  void stop() {
    if (_timer != null) {
      appLogger.i("[ScoreProvider] Stopping timer...");
      _timer?.cancel();
      _timer = null;
    }
  }

  void reset() {
    appLogger.i("[ScoreProvider] Resetting score...");

    _cumulativeSeverity = 0.0;
    _sessionStartTime = null;
    _score = 0.0;
    _highestScore = 0.0;

    notifyListeners();
  }

  void onNewAlert(double severity) {
    _cumulativeSeverity += severity;

    appLogger.i(
        "[ScoreProvider] New alert received, cumulative severity: $_cumulativeSeverity");
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }

  void _updateScore() {
    _recalculateScore();
    appLogger.i(
        "[ScoreProvider] $_sessionStartTime Current score: $_score | Highest score: $_highestScore");
  }

  void _recalculateScore() {
    if (_sessionStartTime == null) {
      _score = 0.0;
    } else {
      final elapsedSeconds =
          DateTime.now().difference(_sessionStartTime!).inSeconds;

      if (elapsedSeconds <= 0) {
        _score = 0.0;
      } else {
        final adjustmentFactor = AdjustmentUtils.calculateAdjustmentFactor(
          elapsedSeconds: elapsedSeconds,
        );
        _score = ((_cumulativeSeverity / elapsedSeconds) * adjustmentFactor)
            .clamp(0.0, 1.0);

        if (_score > _highestScore) {
          _highestScore = _score;
        }
      }
    }

    notifyListeners();
  }
}
