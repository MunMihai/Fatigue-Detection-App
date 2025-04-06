import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:flutter/material.dart';
import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';

class NoAlertsDetectedWidget extends StatelessWidget {
  const NoAlertsDetectedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return Container(
      // height: 200,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 10,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.emoji_events_outlined,
            color: Colors.amber[600],
            size: 60,
          ),
          AppSpaceses.verticalSmall,
          Text(
            tr.noAlertsDetected,
            style: AppTextStyles.h3(context),
            textAlign: TextAlign.center,
          ),
          AppSpaceses.verticalTiny,
          Text(
            tr.sessionWentPerfectly,
            style: AppTextStyles.subtitle,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
