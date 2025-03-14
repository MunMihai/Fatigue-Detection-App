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

  void start({required Duration countdownDuration}) {
    _startTime = DateTime.now();
    _remaining = countdownDuration;
    _elapsed = Duration.zero;
    _countdownFinished = false;

    _startTimer();
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      final now = DateTime.now();
      _elapsed = now.difference(_startTime!);

      if (_remaining > Duration.zero) {
        _remaining -= const Duration(seconds: 1);
        if (_remaining <= Duration.zero) {
          _remaining = Duration.zero;
          _countdownFinished = true;
        }
      }

      notifyListeners();
    });
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void reset() {
    _startTime = null;
    _elapsed = Duration.zero;
    _remaining = Duration.zero;
    _countdownFinished = false;
    stop();
  }
}
