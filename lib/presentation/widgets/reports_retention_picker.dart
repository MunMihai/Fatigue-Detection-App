import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class ReportsRetentionPicker extends StatelessWidget {
  final int months;

  final VoidCallback onIncrementByMonth;
  final VoidCallback onDecrementByMonth;
  final VoidCallback onIncrementByYear;
  final VoidCallback onDecrementByYear;

  const ReportsRetentionPicker({
    super.key,
    required this.months,
    required this.onIncrementByMonth,
    required this.onDecrementByMonth,
    required this.onIncrementByYear,
    required this.onDecrementByYear,
  });

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr.saveReportsFor, style: AppTextStyles.h4),
            Text(tr.tapToSet, style: AppTextStyles.subtitle),
          ],
        ),

        // Right side control
        Row(
          children: [
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_drop_up),
                  iconSize: 30,
                  onPressed: onIncrementByMonth,
                  onLongPress: onIncrementByYear,
                ),
                Text('$months ${tr.months}', style: AppTextStyles.h4),
                IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 30,
                  onPressed: onDecrementByMonth,
                  onLongPress: onDecrementByYear,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
