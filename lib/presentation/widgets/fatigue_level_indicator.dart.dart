import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/domain/enum/fatigue_level.dart';
import 'package:flutter/material.dart';

class FatigueLevelIndicator extends StatelessWidget {
  final double score; 

  const FatigueLevelIndicator({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final double maxScore = 0.6;
    final double normalized = (score / maxScore).clamp(0.0, 1.0);

    final fatigueLevel = FatigueLevelExtension.fromScore(score);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          height: 10,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(5),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: normalized, 
            child: Container(
              decoration: BoxDecoration(
                color: fatigueLevel.color(context),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
        ),
        AppSpaceses.verticalTiny,
        Text(fatigueLevel.label(context),
            style: AppTextStyles.subtitle
                .copyWith(color: fatigueLevel.color(context))),
      ],
    );
  }
}
