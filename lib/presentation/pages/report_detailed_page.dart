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
    return Scaffold(
      appBar: CustomAppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: sessionReport.timestamp.toFormattedDate()),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: [
            AppSpaceses.verticalSmall,

            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        'Started at: ${sessionReport.timestamp.toFormattedTime()}',
                        style: AppTextStyles.timer),
                    Text(
                        'Duration for: ${sessionReport.durationMinutes.toHoursAndMinutes()}',
                        style: AppTextStyles.timer),
                    Text('Fatigue level: ${sessionReport.fatigueLevelLabel}',
                        style: AppTextStyles.timer),
                    Text('Retention for: ${sessionReport.retentionMonths} months',
                        style: AppTextStyles.timer),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 13),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Camera', style: AppTextStyles.h4),
                      Text(sessionReport.camera, style: AppTextStyles.subtitle),
                    ],
                  ),
                ),
              ],
            ),

            AppSpaceses.verticalLarge,

            DetailedSessionReportChart(
              alerts: sessionReport.alerts,
              sessionStartTime: sessionReport.timestamp,
              durationMinutes: sessionReport.durationMinutes,
            ),

            AppSpaceses.verticalLarge,

            /// Lista de alerte
            Text('Alerts', style: AppTextStyles.h2),

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
