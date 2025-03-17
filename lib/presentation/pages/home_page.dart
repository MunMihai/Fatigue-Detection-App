import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/services/session_manager.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';
import 'package:driver_monitoring/presentation/widgets/app_bar.dart';
import 'package:driver_monitoring/presentation/widgets/buttomNavigationBar/buttom_navigation_bar_idle.dart';
import 'package:driver_monitoring/presentation/widgets/buttons/arrow_button.dart';
import 'package:driver_monitoring/presentation/widgets/buttons/camera_connection_statut_button.dart';
import 'package:driver_monitoring/presentation/widgets/buttons/main_monitoring_button.dart';
import 'package:driver_monitoring/presentation/widgets/reports_section.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
              onPressed: () => context.push('/cameraConnection'),
            ),

            AppSpaceses.verticalMedium,

            /// Advanced Settings
            ArrowButton(
              title: 'Advanced Settings',
              onPressed: () => context.push('/settings'),
            ),

            AppSpaceses.verticalLarge,

            /// Main Monitoring Button
            MainMonitoringButton(
              title: 'START MONITORING',
              onPressed: () async {
                if (sessionManager.isIdle) {
                  await sessionManager.startMonitoring();

                  // Dacă totul e ok, mergem pe pagina principală de monitorizare
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

            /// Reports section if enabled
            Consumer<SettingsProvider>(
              builder: (context, settingsProvider, _) =>
                  settingsProvider.isReportsSectionEnabled
                      ? const ReportsSection()
                      : const SizedBox(),
            ),

            AppSpaceses.verticalLarge,
          ],
        ),
      ),

      /// Bottom Navigation Bar in IDLE state
      bottomNavigationBar: const BottomNavBarIDLE(currentIndex: 0),
    );
  }
}
