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
    // ✅ Praguri custom pentru scoruri (modifică după nevoi)
    if (score <= 1 / 60) {
      return FatigueLevel.normal;
    } else if (score <= 2 / 60) {
      return FatigueLevel.good;
    } else if (score <= 3 / 60) {
      return FatigueLevel.moderate;
    } else if (score <= 4 / 60) {
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
}
