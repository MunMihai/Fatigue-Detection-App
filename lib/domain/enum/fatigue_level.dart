enum FatigueLevel { normal, good, moderate, high, extreme }

extension FatigueLevelExtension on FatigueLevel {
  static FatigueLevel fromScore(double score) {
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
}
