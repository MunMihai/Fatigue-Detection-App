import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/services/session_manager.dart';
import 'package:driver_monitoring/core/utils/int_extension.dart';
import 'package:driver_monitoring/presentation/providers/score_provider.dart';
import 'package:driver_monitoring/presentation/widgets/app_bar.dart';
import 'package:driver_monitoring/presentation/widgets/buttons/simple_button.dart';
import 'package:driver_monitoring/presentation/widgets/fatigue_level_indicator.dart.dart';
import 'package:driver_monitoring/presentation/widgets/info_card.dart';
import 'package:driver_monitoring/presentation/widgets/recommendation_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainMonitoringView extends StatefulWidget {
  const MainMonitoringView({super.key});

  @override
  State<MainMonitoringView> createState() => _MainMonitoringViewState();
}

class _MainMonitoringViewState extends State<MainMonitoringView>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: Colors.red.withValues(alpha: 0.7),
      end: Colors.red.withValues(alpha:0.2),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<SessionManager, ScoreProvider>(
      builder: (context, sessionManager, scoreProvider, child) {
        final score = scoreProvider.score;

        final isPaused = sessionManager.isPaused;
        final elapsedTime = sessionManager.sessionTimer.elapsedTime;
        final breakTime = sessionManager.pauseManager.totalPause;
        final breaksCount = sessionManager.breaksCount;

        final bool isFatigued = score >= 0.9;

        return AnimatedBuilder(
          animation: _controller,
          builder: (context, _) {
            return Scaffold(
              appBar: CustomAppBar(
                  title: 'Active Monitoring'),
              backgroundColor: isFatigued
                  ? _colorAnimation.value
                  : Theme.of(context).colorScheme.surface,
              body: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: ListView(
                  children: [
                    AppSpaceses.verticalLarge,
                    Text('Fatigue Level', style: AppTextStyles.h2),
                    AppSpaceses.verticalSmall,
                    FatigueLevelIndicator(score: score),
                    AppSpaceses.verticalLarge,
                    Text('Recommendations', style: AppTextStyles.h2),
                    AppSpaceses.verticalMedium,
                    RecommendationCard(score: score),
                    AppSpaceses.verticalLarge,
                    Row(
                      children: [
                        Expanded(
                          child: InfoCard(
                            title: 'Break Time',
                            value: breakTime.inMinutes.toHoursAndMinutes(),
                          ),
                        ),
                        AppSpaceses.horizontalSmall,
                        Expanded(
                          child: InfoCard(
                            title: 'Breaks',
                            value: '$breaksCount',
                          ),
                        ),
                      ],
                    ),
                    AppSpaceses.verticalSmall,
                    InfoCard(
                      title: 'Total Session Time',
                      value: elapsedTime.inSeconds.toHoursMinutesAndSeconds(),
                      height: 100,
                      width: 340,
                    ),
                    AppSpaceses.verticalMedium,
                    PrimaryButton(
                      title:
                          isPaused ? 'RESUME Monitoring' : 'PAUSE Monitoring',
                      onPressed: () async {
                        if (isPaused) {
                          await sessionManager.resumeMonitoring();
                        } else {
                          await sessionManager.pauseMonitoring();
                        }
                      },
                    ),
                    AppSpaceses.verticalMedium,
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
