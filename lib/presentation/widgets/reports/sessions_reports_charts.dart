import 'dart:math';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/enum/fatigue_level.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';
import 'package:driver_monitoring/domain/entities/session_report.dart';

class SessionsReportsChart extends StatelessWidget {
  final List<SessionReport> reports;

  const SessionsReportsChart({
    super.key,
    required this.reports,
  });

  @override
  Widget build(BuildContext context) {
    final sortedReports = [...reports]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final int totalReports = sortedReports.length;

    final double zoomFactor = totalReports > 10 ? 10 / totalReports : 1.0;
    final double zoomPosition =
        totalReports > 10 ? (totalReports - 10) / totalReports : 0.0;

    return SizedBox(
      child: SfCartesianChart(
        title: ChartTitle(
            text: 'Fatigue Scores',
            textStyle: AppTextStyles.h3,
            alignment: ChartAlignment.near),
        primaryXAxis: CategoryAxis(
          labelRotation: -30,
          labelStyle: AppTextStyles.medium_12,
          initialZoomFactor: zoomFactor,
          initialZoomPosition: zoomPosition,
          rangePadding: ChartRangePadding.none,
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 0.5,
          interval: 0.01,
          isVisible: false,
        ),
        tooltipBehavior: TooltipBehavior(enable: true),
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          enablePanning: true,
          zoomMode: ZoomMode.x,
          enableDoubleTapZooming: true,
        ),
        legend: Legend(isVisible: false),
        series: <CartesianSeries>[
          ColumnSeries<SessionReport, String>(
            dataSource: sortedReports,
            xValueMapper: (SessionReport report, _) =>
                DateFormat('HH:mm\nMMM dd, yyyy').format(report.timestamp),
            yValueMapper: (SessionReport report, _) =>
                min(report.highestSeverityScore, 0.5),
            name: '', // Fără nume pentru legendă
            dataLabelSettings: DataLabelSettings(
              isVisible: true,
              labelAlignment: ChartDataLabelAlignment.middle,
              textStyle: AppTextStyles.medium_12.copyWith(color: Colors.white),
            ),
            dataLabelMapper: (SessionReport report, _) {
              final fatigueLevel =
                  FatigueLevelExtension.fromScore(report.highestSeverityScore);
              return fatigueLevel.label;
            },

            pointColorMapper: (SessionReport report, _) {
              final fatigueLevel =
                  FatigueLevelExtension.fromScore(report.highestSeverityScore);
              return fatigueLevel.color(context);
            },

            markerSettings: const MarkerSettings(isVisible: false),
            onPointTap: (ChartPointDetails details) {
              final index = details.pointIndex;
              if (index != null && index < sortedReports.length) {
                final selectedReport = sortedReports[index];
                context.push('/reports/session/${selectedReport.id}');
              }
            },
          ),
        ],
      ),
    );
  }
}
