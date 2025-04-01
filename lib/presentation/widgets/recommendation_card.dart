import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/domain/enum/fatigue_level.dart';
import 'package:flutter/material.dart';

class RecommendationCard extends StatelessWidget {
  final double score;

  const RecommendationCard({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    final fatigueLevel = FatigueLevelExtension.fromScore(score);

    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(
              fatigueLevel.recommendationIconPath,
              color: Colors.white,
              width: 40,
              height: 40,
            ),
          ),
          AppSpaceses.horizontalSmall,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fatigueLevel.recommendationTitle(context),
                  style: AppTextStyles.h4
                ),
                AppSpaceses.verticalTiny,
                Text(
                  fatigueLevel.recommendationDescription(context),
                  style: AppTextStyles.subtitle
                ),
              ],
            ),
          ),
        ],
      
    );
  }
}
