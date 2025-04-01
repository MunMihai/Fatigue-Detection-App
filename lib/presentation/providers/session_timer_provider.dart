import 'dart:async';
import 'package:flutter/foundation.dart';

class SessionTimer extends ChangeNotifier {
  DateTime? _startTime;

  Duration _elapsed = Duration.zero;
  Duration _remaining = Duration.zero;

  bool _countdownFinished = false;
  Timer? _timer;

  bool get countdownFinished => _countdownFinished;
  Duration get remainingTime => _remaining;
  Duration get elapsedTime => _elapsed;

  bool get isRunning => _timer != null && _timer!.isActive;

  void start({required Duration countdownDuration}) {
    if (isRunning) {
      stop(); 
    }

    if (countdownDuration <= Duration.zero) {
      _countdownFinished = true;
      _elapsed = Duration.zero;
      _remaining = Duration.zero;
      notifyListeners();
      return;
    }

    _startTime = DateTime.now();
    _elapsed = Duration.zero;
    _remaining = countdownDuration;
    _countdownFinished = false;

    _startTimer();
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void reset() {
    stop();
    _startTime = null;
    _elapsed = Duration.zero;
    _remaining = Duration.zero;
    _countdownFinished = false;

    notifyListeners();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();

      if (_startTime == null) return;

      _elapsed = now.difference(_startTime!);
      _remaining = _remaining - const Duration(seconds: 1);

      if (_remaining.isNegative) {
        _remaining = Duration.zero;
      }

      final finished = _remaining <= Duration.zero;

      if (finished && !_countdownFinished) {
        _countdownFinished = true;
      }

      notifyListeners();
    });
  }
}
