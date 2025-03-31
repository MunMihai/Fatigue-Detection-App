import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:driver_monitoring/core/utils/date_time_extension.dart';
import 'package:driver_monitoring/core/utils/int_extension.dart';
import 'package:driver_monitoring/domain/entities/session_report.dart';
import 'package:driver_monitoring/presentation/widgets/app_bar.dart';
import 'package:driver_monitoring/presentation/widgets/buttons/delete_report_button.dart';
import 'package:driver_monitoring/presentation/widgets/reports/alert_item.dart';
import 'package:driver_monitoring/presentation/widgets/reports/detailed_session_reports.dart/detailed_session_report_chart.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/constants/app_spaceses.dart';

class ReportDetailedPage extends StatelessWidget {
  final SessionReport sessionReport;

  const ReportDetailedPage({
    super.key,
    required this.sessionReport,
  });

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!; 
    return Scaffold(
      appBar: CustomAppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: sessionReport.timestamp.toFormattedDate(context)),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: [
            AppSpaceses.verticalSmall,

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${tr.startedAt}: ${sessionReport.timestamp.toFormattedTime(context)}',
                    style: AppTextStyles.timer),
                Text(
                    '${tr.durationFor}: ${sessionReport.durationMinutes.toHoursAndMinutes(context)}',
                    style: AppTextStyles.timer),
                Text('${tr.fatigueLevel}: ${sessionReport.fatigueLevelLabel(context)}',
                    style: AppTextStyles.timer),
                Text('${tr.retentionFor}: ${sessionReport.retentionMonths} ${tr.months}',
                    style: AppTextStyles.timer),
              ],
            ),

            AppSpaceses.verticalLarge,

            DetailedSessionReportChart(
              alerts: sessionReport.alerts,
              sessionStartTime: sessionReport.timestamp,
              durationMinutes: sessionReport.durationMinutes,
            ),

            AppSpaceses.verticalLarge,

            Text(tr.alerts, style: AppTextStyles.h2),

            AppSpaceses.verticalMedium,

            ...sessionReport.alerts.map((alert) => AlertItem(alert: alert)),

            AppSpaceses.verticalLarge,

            DeleteReportButton(reportId: sessionReport.id),

            AppSpaceses.verticalLarge,
          ],
        ),
      ),
    );
  }
}
