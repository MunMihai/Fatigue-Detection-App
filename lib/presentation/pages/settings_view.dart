import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';
import 'package:driver_monitoring/presentation/widgets/app_bar.dart';
import 'package:driver_monitoring/presentation/widgets/buttons/custom_switch_tile.dart';
import 'package:driver_monitoring/presentation/widgets/reports_retention_picker.dart';
import 'package:driver_monitoring/presentation/widgets/time_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();
    final tr = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(
        title: tr.settingsTitle,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            AppSpaceses.verticalSmall,
            Text(tr.fatigueCounter, style: AppTextStyles.h2(context)),
            AppSpaceses.verticalMedium,
            CustomSwitchTile(
              title: tr.enableCounter,
              subtitle: tr.toggleOnOff,
              value: settingsProvider.isCounterEnabled,
              onChanged: settingsProvider.toggleCounter,
            ),
            settingsProvider.isCounterEnabled
                ? TimePicker(
                    hours: settingsProvider.savedHours,
                    minutes: settingsProvider.savedMinutes,
                    onChanged: settingsProvider.updateTime,
                  )
                : AppSpaceses.verticalLarge,
            Text(tr.preferences, style: AppTextStyles.h2(context)),
            AppSpaceses.verticalMedium,
            CustomSwitchTile(
                title: tr.enableAccurateMode,
                subtitle: tr.accuracyWarning,
                value: settingsProvider.faceDetectorMode ==
                    FaceDetectorMode.accurate,
                onChanged: (value) async {
                  await settingsProvider.updateFaceDetectorMode(
                    value ? FaceDetectorMode.accurate : FaceDetectorMode.fast,
                  );
                }),
            AppSpaceses.verticalMedium,
            CustomSwitchTile(
              title: tr.enableNightLight, 
              subtitle: tr.nightLightSubtitle,
              value: settingsProvider.isNightLightEnabled,
              onChanged: settingsProvider.toggleNightLight,
            ),
            AppSpaceses.verticalMedium,
            CustomSwitchTile(
              title: tr.showReportsSection,
              subtitle: tr.toggleShowHide,
              value: settingsProvider.isReportsSectionEnabled,
              onChanged: settingsProvider.toggleReportsSection,
            ),
            ReportsRetentionPicker(
              months: settingsProvider.retentionMonths,
              onIncrementByMonth: settingsProvider.incrementRetentionMonths,
              onDecrementByMonth: settingsProvider.decrementRetentionMonths,
              onIncrementByYear: settingsProvider.incrementRetentionByYear,
              onDecrementByYear: settingsProvider.decrementRetentionByYear,
            )
          ],
        ),
      ),
    );
  }
}
