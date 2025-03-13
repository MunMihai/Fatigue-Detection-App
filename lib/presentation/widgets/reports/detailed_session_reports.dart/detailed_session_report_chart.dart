import 'package:driver_monitoring/presentation/widgets/reports/detailed_session_reports.dart/alert_density_chart.dart';
import 'package:driver_monitoring/presentation/widgets/reports/detailed_session_reports.dart/chart_data_utils.dart';
import 'package:driver_monitoring/presentation/widgets/reports/detailed_session_reports.dart/no_alerts_detected_widget.dart';
import 'package:flutter/material.dart';
import 'package:driver_monitoring/domain/entities/alert.dart';


class DetailedSessionReportChart extends StatelessWidget {
  final List<Alert> alerts;
  final DateTime sessionStartTime;
  final int durationMinutes;

  const DetailedSessionReportChart({
    super.key,
    required this.alerts,
    required this.sessionStartTime,
    required this.durationMinutes,
  });

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) {
      return const NoAlertsDetectedWidget();
    }

    final sortedAlerts = [...alerts]..sort((a, b) => a.timestamp.compareTo(b.timestamp));

    final controlPoints = ChartDataUtils.buildControlPoints(
      sortedAlerts,
      sessionStartTime,
      durationMinutes,
    );

    final interpolatedPoints = ChartDataUtils.generateLinearPoints(
      controlPoints,
      sessionStartTime,
    );

    return AlertDensityChart(points: interpolatedPoints);
  }
}
