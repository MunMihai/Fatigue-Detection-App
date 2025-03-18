import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/services/session_manager.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';
import 'package:driver_monitoring/presentation/widgets/app_bar.dart';
import 'package:driver_monitoring/presentation/widgets/buttons/arrow_button.dart';
import 'package:driver_monitoring/presentation/widgets/buttons/camera_connection_statut_button.dart';
import 'package:driver_monitoring/presentation/widgets/buttons/main_monitoring_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  final Function(int)? onChangeTab;

  const HomeView({super.key, this.onChangeTab});

  @override
  Widget build(BuildContext context) {
    final sessionManager = context.watch<SessionManager>();

    return Scaffold(
      appBar: CustomAppBar(title: 'Home'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: [
            AppSpaceses.verticalLarge,

            /// Title
            Text('Set Up your system', style: AppTextStyles.h2),

            AppSpaceses.verticalMedium,

            /// Camera status button (External Camera Setup)
            CameraStatusButton(
              title: 'External Camera',
              status: 'Connect',
              onPressed: () {},
            ),

            AppSpaceses.verticalMedium,

            /// Advanced Settings
            ArrowButton(
              title: 'Advanced Settings',
              onPressed: () {
                onChangeTab?.call(2); 
              },
            ),

            AppSpaceses.verticalLarge,

            MainMonitoringButton(
              title: 'START MONITORING',
              onPressed: () async {
                if (sessionManager.isIdle) {
                  await sessionManager.startMonitoring();

                  if (!context.mounted) return;

                  context.go('/activeMonitoring/main');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Session already active!')),
                  );
                }
              },
            ),

            AppSpaceses.verticalLarge,

            Consumer<SettingsProvider>(
              builder: (context, settingsProvider, _) =>
                  settingsProvider.isReportsSectionEnabled
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                              Text('Reports', style: AppTextStyles.h2),
                              AppSpaceses.verticalMedium,
                              ArrowButton(
                                  title: 'View driving session reports',
                                  onPressed: () {
                                    onChangeTab?.call(
                                        1);
                                  })
                            ])
                      : const SizedBox(),
            ),

            AppSpaceses.verticalLarge,
          ],
        ),
      ),
    );
  }
}
