import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/presentation/controllers/settings_controller.dart';
import 'package:driver_monitoring/presentation/widgets/app_bar.dart';
import 'package:driver_monitoring/presentation/widgets/buttomNavigationBar/buttom_navigation_bar_idle.dart';
import 'package:driver_monitoring/presentation/widgets/buttons/custom_switch_tile.dart';
import 'package:driver_monitoring/presentation/widgets/reports_retention_picker.dart';
import 'package:driver_monitoring/presentation/widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SettingsController>();

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Sistem Settings',
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppSpaceses.verticalLarge,
            Text('Fatigue Counter', style: AppTextStyles.h2),
            AppSpaceses.verticalMedium,
            CustomSwitchTile(
              title: 'Enable Counter',
              subtitle: 'Toggle on/off',
              value: controller.isCounterEnabled,
              onChanged: controller.toggleCounter,
            ),
            if (controller.isCounterEnabled)
              TimePicker(
                hours: controller.savedHours,
                minutes: controller.savedMinutes,
                onChanged: controller.updateTime,
              ),
            AppSpaceses.verticalLarge,
            Text('Reports Configuration', style: AppTextStyles.h2),
            AppSpaceses.verticalMedium,
            CustomSwitchTile(
              title: 'Show Reports Section',
              subtitle: 'Toggle to show/hide',
              value: controller.isReportsSectionEnabled,
              onChanged: controller.toggleReportsSection,
            ),
            ReportsRetentionPicker(
                months: controller.retentionMonths,
                onIncrement: controller.incrementRetentionMonths,
                onDecrement: controller.decrementRetentionMonths)
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarIDLE(currentIndex: 2),
    );
  }
}
