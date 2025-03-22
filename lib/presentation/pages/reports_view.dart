import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/presentation/providers/session_report_provider.dart';
import 'package:driver_monitoring/presentation/widgets/app_bar.dart';
import 'package:driver_monitoring/presentation/widgets/reports/sessions_reports_charts.dart';
import 'package:driver_monitoring/presentation/widgets/reports/session_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ReportsView extends StatelessWidget {
  const ReportsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Reports',
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: Consumer<SessionReportProvider>(
          builder: (context, reportProvider, child) {
            final reports = reportProvider.reports;
            final isLoading =
                reportProvider.isLoading; // dacă ai adăugat loading

            if (isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (reports.isEmpty) {
              return const Center(child: Text('No reports found.'));
            }

            return ListView(
  // padding: const EdgeInsets.symmetric(horizontal: 25),
  children: [
    SessionsReportsChart(reports: reports),
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Sessions', style: AppTextStyles.h2),
        GestureDetector(
          onTap: () => context.push('/allSessions'),
          child: Text('View All', style: AppTextStyles.h4),
        ),
      ],
    ),
    AppSpaceses.verticalMedium,
    ...reports.reversed.take(5).map((session) => SessionCard(sessionReport: session)),
  ],
);

          },
        ),
      ),
    );
  }
}
