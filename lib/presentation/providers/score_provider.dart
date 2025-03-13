import 'dart:async';

import 'package:flutter/material.dart';

class ScoreProvider extends ChangeNotifier {
  double _score = 0.0;
  Timer? _timer;
  bool _state = false;

  double get score => _score;
  bool get state => _state;

  void updateScore(double newScore) {
    _score = newScore;
    notifyListeners();
  }

  void startSimulatingScore() {
    // Verifică dacă e deja pornit, previne instanțe multiple
    if (_timer != null) return;

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _score += 0.002;
      if (_score > 0.1) _score = 0;
      notifyListeners();
    });

    _state = true;
    notifyListeners();
  }

  void stopSimulatingScore() {
    _timer?.cancel();
    _timer = null;

    _state = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
