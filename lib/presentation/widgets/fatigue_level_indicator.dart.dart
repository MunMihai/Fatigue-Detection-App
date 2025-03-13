import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/enum/fatigue_level.dart';
import 'package:flutter/material.dart';

class FatigueLevelIndicator extends StatelessWidget {
  final double score; // scor între 0 și 0.1

  const FatigueLevelIndicator({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    // Normalizează scorul pe scala 0.0 - 1.0, unde 0.1 = 100%
    final double normalized = (score / 0.1).clamp(0.0, 1.0);

    // Determină nivelul de oboseală pe baza scorului
    final fatigueLevel = FatigueLevelExtension.fromScore(score);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 340,
          height: 10,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(5),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: normalized, // între 0.0 și 1.0
            child: Container(
              decoration: BoxDecoration(
                color: fatigueLevel.color(context),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        AppSpaceses.verticalTiny,
        Text(fatigueLevel.label,
            style: AppTextStyles.subtitle
                .copyWith(color: fatigueLevel.color(context))),
      ],
    );
  }
}
