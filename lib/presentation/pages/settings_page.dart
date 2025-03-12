import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';
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
    final settingsProvider = context.watch<SettingsProvider>();

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
              value: settingsProvider.isCounterEnabled,
              onChanged: settingsProvider.toggleCounter,
            ),
            if (settingsProvider.isCounterEnabled)
              TimePicker(
                hours: settingsProvider.savedHours,
                minutes: settingsProvider.savedMinutes,
                onChanged: settingsProvider.updateTime,
              ),
            AppSpaceses.verticalLarge,
            Text('Reports Configuration', style: AppTextStyles.h2),
            AppSpaceses.verticalMedium,
            CustomSwitchTile(
              title: 'Show Reports Section',
              subtitle: 'Toggle to show/hide',
              value: settingsProvider.isReportsSectionEnabled,
              onChanged: settingsProvider.toggleReportsSection,
            ),
            ReportsRetentionPicker(
                months: settingsProvider.retentionMonths,
                onIncrement: settingsProvider.incrementRetentionMonths,
                onDecrement: settingsProvider.decrementRetentionMonths)
          ],
        ),
      ),
      bottomNavigationBar: const BottomNavBarIDLE(currentIndex: 2),
    );
  }
}
