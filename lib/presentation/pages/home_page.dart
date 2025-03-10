import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/presentation/controllers/settings_controller.dart';
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
    return Scaffold(
      appBar: CustomAppBar(title: 'Home'),
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppSpaceses.verticalLarge,
              Text('Set Up your system', style: AppTextStyles.h2),
              AppSpaceses.verticalMedium,
              CameraStatusButton(
                  title: 'External Camera',
                  status: 'Connect',
                  onPressed: () => context.push(
                        '/cameraConnection',
                      )),
              AppSpaceses.verticalMedium,
              ArrowButton(
                  title: 'Advanced Settings',
                  onPressed: () => context.push('/settings')),
              AppSpaceses.verticalLarge,
              MainMonitoringButton(
                  title: 'START MONITORING',
                  onPressed: () => context.go('/activeMonitoring/main')),
              AppSpaceses.verticalLarge,
              Consumer<SettingsController>(
                  builder: (context, settingsController, _) =>
                      settingsController.isReportsSectionEnabled
                          ? ReportsSection()
                          : SizedBox()),
            ],
          )),
      bottomNavigationBar: const BottomNavBarIDLE(currentIndex: 0),
    );
  }
}
