import 'dart:async';
import 'package:flutter/foundation.dart';

class PauseManager extends ChangeNotifier {
  DateTime? _pauseStartTime;
  Duration _totalPauseDuration = Duration.zero;
  bool _isPaused = false;

  Timer? _pauseTimer;

  bool get isPaused => _isPaused;

  Duration get totalPause {
    if (_isPaused && _pauseStartTime != null) {
      final currentPause = DateTime.now().difference(_pauseStartTime!);
      return _totalPauseDuration + currentPause;
    }
    return _totalPauseDuration;
  }

  void startPause() {
    if (_isPaused) return;

    _pauseStartTime = DateTime.now();
    _isPaused = true;

    _startPauseTimer();

    notifyListeners();
  }

  void stopPause() {
    if (!_isPaused || _pauseStartTime == null) return;

    _totalPauseDuration += DateTime.now().difference(_pauseStartTime!);

    _pauseStartTime = null;
    _isPaused = false;

    _stopPauseTimer();

    notifyListeners();
  }

  void reset() {
    final wasPausedOrNotEmpty = _isPaused || _totalPauseDuration != Duration.zero;

    _pauseStartTime = null;
    _totalPauseDuration = Duration.zero;
    _isPaused = false;

    _stopPauseTimer();

    if (wasPausedOrNotEmpty) {
      notifyListeners();
    }
  }

  void _startPauseTimer() {
    _pauseTimer?.cancel();
    _pauseTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      notifyListeners();
    });
  }

  void _stopPauseTimer() {
    _pauseTimer?.cancel();
    _pauseTimer = null;
  }

  @override
  void dispose() {
    _stopPauseTimer();
    super.dispose();
  }
}
