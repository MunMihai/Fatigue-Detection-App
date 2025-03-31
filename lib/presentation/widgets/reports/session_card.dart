import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/utils/date_time_extension.dart';
import 'package:driver_monitoring/domain/entities/session_report.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SessionCard extends StatelessWidget {
  final SessionReport sessionReport;

  const SessionCard({
    super.key,
    required this.sessionReport,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/reports/session/${sessionReport.id}');
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.all(Radius.circular(15))
              ),
              child: const Icon(Icons.show_chart_sharp, size: 40),
            ),

            const SizedBox(width: 20),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    sessionReport.timestamp.toFormattedDate(context),
                    style: AppTextStyles.h4,
                  ),
                  AppSpaceses.verticalTiny,
                  Text(
                    sessionReport.fatigueLevelLabel(context),
                    style: AppTextStyles.subtitle,
                  ),
                ],
              ),
            ),

            const Icon(Icons.chevron_right, size: 30 ),
          ],
        ),
      ),
    );
  }
}
