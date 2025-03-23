import 'package:flutter/material.dart';

enum FatigueLevel { normal, good, moderate, high, extreme }

extension FatigueLevelExtension on FatigueLevel {
  String get label {
    switch (this) {
      case FatigueLevel.normal:
        return 'Normal';
      case FatigueLevel.good:
        return 'Good';
      case FatigueLevel.moderate:
        return 'Moderate';
      case FatigueLevel.high:
        return 'High';
      case FatigueLevel.extreme:
        return 'Extreme';
    }
  }

  static FatigueLevel fromScore(double score) {
    if (score <= 0.1) {
      return FatigueLevel.normal;
    } else if (score <= 0.2) {
      return FatigueLevel.good;
    } else if (score <= 0.3) {
      return FatigueLevel.moderate;
    } else if (score <= 0.4) {
      return FatigueLevel.high;
    } else {
      return FatigueLevel.extreme;
    }
  }

  Color color(BuildContext context) {
    switch (this) {
      case FatigueLevel.normal:
        return Colors.green;
      case FatigueLevel.good:
        return Colors.lightGreen;
      case FatigueLevel.moderate:
        return Colors.orange;
      case FatigueLevel.high:
        return Colors.deepOrange;
      case FatigueLevel.extreme:
        return Theme.of(context).colorScheme.error;
    }
  }

  String get recommendationTitle {
    switch (this) {
      case FatigueLevel.normal:
        return 'Stay Focused';
      case FatigueLevel.good:
        return 'Maintain Awareness';
      case FatigueLevel.moderate:
        return 'Be Cautious';
      case FatigueLevel.high:
        return 'Take a Break';
      case FatigueLevel.extreme:
        return 'Stop Driving!';
    }
  }

  String get recommendationDescription {
    switch (this) {
      case FatigueLevel.normal:
        return 'Keep your eyes on the road while we keep ours on you. Stay focused and drive safely!';
      case FatigueLevel.good:
        return 'Take deep breaths and ensure proper ventilation. Fresh air can help you stay alert!';
      case FatigueLevel.moderate:
        return 'Your reaction time is slowing. Take a short break and grab a strong coffee!';
      case FatigueLevel.high:
        return 'Your alertness is low. Take a break now—coffee might help, but rest is key!';
      case FatigueLevel.extreme:
        return 'Extreme fatigue detected! Stop driving immediately and rest before continuing.';
    }
  }

  IconData get recommendationIcon {
    switch (this) {
      case FatigueLevel.normal:
        return Icons.visibility;
      case FatigueLevel.good:
        return Icons.remove_red_eye_outlined;
      case FatigueLevel.moderate:
        return Icons.warning_amber_outlined;
      case FatigueLevel.high:
        return Icons.error_outline;
      case FatigueLevel.extreme:
        return Icons.report_problem_outlined;
    }
  }

  String get recommendationIconPath {
    switch (this) {
      case FatigueLevel.normal:
        return 'assets/images/Eye.png';
      case FatigueLevel.good:
        return 'assets/images/breath.png';
      case FatigueLevel.moderate:
        return 'assets/images/coffee.png';
      case FatigueLevel.high:
        return 'assets/images/warning.png';
      case FatigueLevel.extreme:
        return 'assets/images/service key.png';
    }
  }
}
