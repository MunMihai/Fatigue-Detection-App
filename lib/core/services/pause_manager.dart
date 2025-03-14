import 'dart:async';
import 'package:flutter/foundation.dart';

class PauseManager extends ChangeNotifier {
  DateTime? _pauseStart;
  Duration _totalPause = Duration.zero;
  bool _isPaused = false;

  Timer? _pauseTimer;

  bool get isPaused => _isPaused;

  /// Timpul total de pauză actualizat în timp real
  Duration get totalPause {
    if (_isPaused && _pauseStart != null) {
      final currentPauseDuration = DateTime.now().difference(_pauseStart!);
      return _totalPause + currentPauseDuration;
    } else {
      return _totalPause;
    }
  }

  void startPause() {
    if (_isPaused) return;

    _pauseStart = DateTime.now();
    _isPaused = true;

    // Pornim timerul care notifică UI-ul să se actualizeze pe fiecare secundă
    _pauseTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      notifyListeners();
    });

    notifyListeners();
  }

  void stopPause() {
    if (!_isPaused || _pauseStart == null) return;

    // Calculăm durata pauzei și o adăugăm la total
    final pauseDuration = DateTime.now().difference(_pauseStart!);
    _totalPause += pauseDuration;

    _pauseStart = null;
    _isPaused = false;

    _pauseTimer?.cancel();
    _pauseTimer = null;

    notifyListeners();
  }

  void reset() {
    _pauseStart = null;
    _totalPause = Duration.zero;
    _isPaused = false;

    _pauseTimer?.cancel();
    _pauseTimer = null;

    notifyListeners();
  }
}
