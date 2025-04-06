import 'package:driver_monitoring/domain/enum/alert_type.dart';
import 'package:driver_monitoring/core/utils/date_time_extension.dart';
import 'package:driver_monitoring/domain/entities/alert.dart';
import 'package:flutter/material.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/constants/app_spaceses.dart';

class AlertItem extends StatelessWidget {
  final Alert alert;

  const AlertItem({
    super.key,
    required this.alert,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              alert.timestamp.toFormattedTime(context),
              style: AppTextStyles.h4(context),
            ),
          ),
          AppSpaceses.horizontalMedium,
          Expanded(
            child: Text(
              AlertType.values.byName(alert.type).localizedDescription(context),
              // alert.type,
              style: AppTextStyles.h4(context),
            ),
          ),
        ],
      ),
    );
  }
}
