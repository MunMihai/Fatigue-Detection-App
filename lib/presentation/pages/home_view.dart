import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/presentation/providers/session_manager.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';
import 'package:driver_monitoring/presentation/widgets/app_bar.dart';
import 'package:driver_monitoring/presentation/widgets/buttons/arrow_button.dart';
import 'package:driver_monitoring/presentation/widgets/buttons/main_monitoring_button.dart';
import 'package:driver_monitoring/presentation/widgets/sensibility_slider.dart';
import 'package:driver_monitoring/presentation/widgets/settings_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  final Function(int)? onChangeTab;

  const HomeView({super.key, this.onChangeTab});

  @override
  Widget build(BuildContext context) {
    final sessionManager = context.watch<SessionManager>();
    final settingsProvider = context.watch<SettingsProvider>();
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        title: tr.homeTitle,
        actions: [
          SettingsMenuButton(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: [
            AppSpaceses.verticalMedium,
            Text(tr.setupYourSystem, style: AppTextStyles.h2(context)),
            AppSpaceses.verticalMedium,
            SensibilitySlider(
              sensitivity: settingsProvider.sessionSensitivity,
              onChanged: (newValue) {
                settingsProvider.updateSessionSensibility(newValue);
              },
            ),
            AppSpaceses.verticalMedium,
            ArrowButton(
              title: tr.advancedSettings,
              onPressed: () {
                onChangeTab?.call(2);
              },
            ),
            AppSpaceses.verticalLarge,
            MainMonitoringButton(
              title: tr.startMonitoring,
              onPressed: () async {
                if (sessionManager.isIdle) {
                  if (!context.mounted) return;
                  context.go('/monitoring');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(tr.sessionAlreadyActive)),
                  );
                }
              },
            ),
            AppSpaceses.verticalLarge,
            if (settingsProvider.isReportsSectionEnabled)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tr.reports, style: AppTextStyles.h2(context)),
                  AppSpaceses.verticalMedium,
                  ArrowButton(
                    title: tr.sessionsHistory,
                    onPressed: () => onChangeTab?.call(1),
                  ),
                ],
              ),
            AppSpaceses.verticalLarge,
          ],
        ),
      ),
    );
  }
}
