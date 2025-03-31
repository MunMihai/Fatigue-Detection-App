import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

enum FatigueLevel { normal, good, moderate, high, extreme }

extension FatigueLevelExtension on FatigueLevel {
  String label(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    switch (this) {
      case FatigueLevel.normal:
        return tr.fatigueLevelNormal;
      case FatigueLevel.good:
        return tr.fatigueLevelGood;
      case FatigueLevel.moderate:
        return tr.fatigueLevelModerate;
      case FatigueLevel.high:
        return tr.fatigueLevelHigh;
      case FatigueLevel.extreme:
        return tr.fatigueLevelExtreme;
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

  String recommendationTitle(context) {
    final tr = AppLocalizations.of(context)!;

    switch (this) {
      case FatigueLevel.normal:
        return tr.fatigueRecTitleNormal;
      case FatigueLevel.good:
        return tr.fatigueRecTitleGood;
      case FatigueLevel.moderate:
        return tr.fatigueRecTitleModerate;
      case FatigueLevel.high:
        return tr.fatigueRecTitleHigh;
      case FatigueLevel.extreme:
        return tr.fatigueRecTitleExtreme;
    }
  }

  String recommendationDescription(context) {
    final tr = AppLocalizations.of(context)!;

    switch (this) {
      case FatigueLevel.normal:
        return tr.fatigueRecDescNormal;
      case FatigueLevel.good:
        return tr.fatigueRecDescGood;
      case FatigueLevel.moderate:
        return tr.fatigueRecDescModerate;
      case FatigueLevel.high:
        return tr.fatigueRecDescHigh;
      case FatigueLevel.extreme:
        return tr.fatigueRecDescExtreme;
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
