import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:driver_monitoring/presentation/providers/settings_provider.dart';

class SensibilitySlider extends StatelessWidget {
  const SensibilitySlider({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, _) {
        final sensitivity = settingsProvider.sessionSensitivity;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr.detectionSensitivity, style: AppTextStyles.h4),
            Slider(
              value: sensitivity.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: '$sensitivity',
              onChanged: (double newValue) {
                settingsProvider.updateSessionSensibility(newValue.round());
              },
            ),
            Text(
              '${tr.currentSensitivity}: $sensitivity',
              style: AppTextStyles.subtitle,
            ),
          ],
        );
      },
    );
  }
}
