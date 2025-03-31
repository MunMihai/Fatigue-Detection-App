import 'package:driver_monitoring/core/enum/alert_type.dart';
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
    final filteredAlerts = alerts
        .where(
          (alert) => alert.type != AlertType.sessionExpired.name,
        )
        .toList();

    if (filteredAlerts.isEmpty) {
      return const NoAlertsDetectedWidget();
    }

    final sortedAlerts = [...filteredAlerts]
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));

final stepInSeconds = (durationMinutes * 60 / 15).floor().clamp(60, 300);
    final scorePoints = ChartDataUtils.generateSessionScorePoints(
      context: context,
      sortedAlerts: sortedAlerts,
      sessionStartTime: sessionStartTime,
      durationMinutes: durationMinutes,
      stepInSeconds: stepInSeconds,
    );

    return AlertDensityChart(points: scorePoints);
  }
}
