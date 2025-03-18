import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/services/session_manager.dart';
import 'package:driver_monitoring/core/utils/int_extension.dart';
import 'package:driver_monitoring/presentation/widgets/app_bar.dart';
import 'package:driver_monitoring/presentation/widgets/buttons/simple_button.dart';
import 'package:driver_monitoring/presentation/widgets/fatigue_level_indicator.dart.dart';
import 'package:driver_monitoring/presentation/widgets/info_card.dart';
import 'package:driver_monitoring/presentation/widgets/recommendation_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainMonitoringView extends StatelessWidget {
  const MainMonitoringView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SessionManager>(
      builder: (context, sessionManager, child) {
        final score = sessionManager.alertManager.averageSeverity;

        /// Stări actualizate
        final isMonitoring = sessionManager.isActive;
        final isPaused = sessionManager.isPaused;

        final elapsedTime = sessionManager.sessionTimer.elapsedTime;
        final breakTime = sessionManager.pauseManager.totalPause;
        final breaksCount = sessionManager.breaksCount;

        return Scaffold(
          appBar: CustomAppBar(title: 'Active Monitoring'),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: ListView(
              children: [
                AppSpaceses.verticalLarge,

                /// Fatigue level
                Text('Fatigue Level', style: AppTextStyles.h2),
                AppSpaceses.verticalSmall,
                FatigueLevelIndicator(score: score),

                AppSpaceses.verticalLarge,

                /// Recommendations
                Text('Recommendations', style: AppTextStyles.h2),
                AppSpaceses.verticalMedium,
                RecommendationCard(score: score),

                AppSpaceses.verticalLarge,

                /// Info cards for breaks & time
                Row(
                  children: [
                    InfoCard(
                      title: 'Break Time',
                      value: breakTime.inMinutes.toHoursAndMinutes(),
                      width: 170,
                      height: 100,
                    ),
                    AppSpaceses.horizontalSmall,
                    InfoCard(
                      title: 'Breaks',
                      value: '$breaksCount',
                      width: 154,
                      height: 100,
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

                /// Button: Pause/Resume Monitoring
                if (isMonitoring || isPaused)
                  PrimaryButton(
                    title: isPaused ? 'RESUME Monitoring' : 'PAUSE Monitoring',
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
  }
}
