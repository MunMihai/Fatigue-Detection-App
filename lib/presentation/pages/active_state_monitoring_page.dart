import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/presentation/providers/score_provider.dart';
import 'package:driver_monitoring/presentation/widgets/app_bar.dart';
import 'package:driver_monitoring/presentation/widgets/buttomNavigationBar/bottom_navigation_bar_active.dart';
import 'package:driver_monitoring/presentation/widgets/buttons/simple_button.dart';
import 'package:driver_monitoring/presentation/widgets/fatigue_level_indicator.dart.dart';
import 'package:driver_monitoring/presentation/widgets/info_card.dart';
import 'package:driver_monitoring/presentation/widgets/recommendation_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ActiveMonitoringMainPage extends StatelessWidget {
  const ActiveMonitoringMainPage({super.key});
  @override
  Widget build(BuildContext context) {
    final scoreProvider = context.watch<ScoreProvider>();
    final score = scoreProvider.score;
    final isMonitoring = scoreProvider.state;

    return Scaffold(
        appBar: CustomAppBar(title: 'Active Monitoring'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: ListView(
            children: [
              AppSpaceses.verticalLarge,
              Text(
                'Fatigue Level',
                style: AppTextStyles.h2,
              ),
              AppSpaceses.verticalSmall,
              FatigueLevelIndicator(score: score),
              AppSpaceses.verticalLarge,
              Text(
                'Recommendations',
                style: AppTextStyles.h2,
              ),
              AppSpaceses.verticalMedium,
              RecommendationCard(score: score),
              AppSpaceses.verticalLarge,
              Row(
                children: [
                  InfoCard(
                    title: 'Break Time',
                    value: '00h 00min',
                    width: 170,
                    height: 100,
                  ),
                  AppSpaceses.horizontalSmall,
                  InfoCard(
                    title: 'Breaks',
                    value: '0',
                    width: 154,
                    height: 100,
                  ),
                ],
              ),
              AppSpaceses.verticalSmall,
              InfoCard(
                  title: 'Total Session Time',
                  value: '02h 00min',
                  height: 100,
                  width: 340),
              AppSpaceses.verticalMedium,
              PrimaryButton(
                title: isMonitoring ? 'STOP Monitoring' : 'START Monitoring',
                onPressed: () {
                  if (isMonitoring) {
                    context.read<ScoreProvider>().stopSimulatingScore();
                  } else {
                    context.read<ScoreProvider>().startSimulatingScore();
                  }
                },
              ),
              AppSpaceses.verticalMedium
            ],
          ),
        ),
        bottomNavigationBar: const BottomNavBarActive(currentIndex: 0));
  }
}
