import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class ReportsRetentionPicker extends StatelessWidget {
  final int months;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const ReportsRetentionPicker({
    super.key,
    required this.months,
    required this.onIncrement,
    required this.onDecrement,
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
                  onLongPress: () {
                    for (int i = 0; i < 12; i++) {
                      onIncrement();
                    }
                  },
                  onPressed: onIncrement,
                ),
                Text('$months months', style: AppTextStyles.h4),
                IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 30,
                  onLongPress: () {
                    for (int i = 0; i < 12; i++) {
                      onDecrement();
                    }
                  },
                  onPressed: onDecrement,
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
