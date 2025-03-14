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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left side text
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Save Reports For', style: AppTextStyles.h4),
            Text('Tap to set', style: AppTextStyles.subtitle),
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
                Text('$months months', style: AppTextStyles.h4),
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
