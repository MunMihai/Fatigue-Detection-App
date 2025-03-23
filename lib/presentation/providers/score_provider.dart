import 'dart:async';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:flutter/foundation.dart';

class ScoreProvider with ChangeNotifier {
  double _cumulativeSeverity = 0.0;
  DateTime? _firstAlertTime;
  double _score = 0.0;
  double _highestScore = 0.0;
  Timer? _timer;

  double get score => _score;
  get highestScore => _highestScore;

  ScoreProvider() {
    _timer = Timer.periodic(Duration(seconds: 1), (_) => _updateScore());
  }

  void onNewAlert(double severity) {
    _firstAlertTime ??= DateTime.now();
    _cumulativeSeverity += severity;
  }

  void _updateScore() {
    appLogger.i("[ScoreProvider]  Current score: $_score");
    appLogger.i("[ScoreProvider]  Higest score: $_highestScore");
    _recalculateScore();
  }

  void _recalculateScore() {
    if (_firstAlertTime == null) {
      _score = 0.0;
    } else {
      final elapsedMinutes =
          DateTime.now().difference(_firstAlertTime!).inMinutes;
      _score = _cumulativeSeverity / (elapsedMinutes + 1);
       if (_score > _highestScore) {
        _highestScore = _score;
      }
    }
    notifyListeners();
  }

  void reset() {
    _cumulativeSeverity = 0.0;
    _firstAlertTime = null;
    _score = 0.0;
    _highestScore = 0.0;

    _timer?.cancel();
    _timer = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
