import 'package:driver_monitoring/core/utils/adjustment_utils.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/core/utils/date_time_extension.dart';
import 'package:driver_monitoring/domain/entities/alert.dart';
import 'package:driver_monitoring/domain/entities/alert_density_point.dart';
import 'package:flutter/material.dart';

class ChartDataUtils {
  static List<AlertDensityPoint> generateSessionScorePoints({
    required BuildContext context, 
    required List<Alert> sortedAlerts,
    required DateTime sessionStartTime,
    required int durationMinutes,
    int stepInSeconds = 60,
  }) {
    final points = <AlertDensityPoint>[];

    if (durationMinutes <= 0) return points;

    final alertsByMinute = <int, List<Alert>>{};

    for (var alert in sortedAlerts) {
      final elapsedMinute =
          alert.timestamp.difference(sessionStartTime).inMinutes;
      alertsByMinute.putIfAbsent(elapsedMinute, () => []).add(alert);
    }

    double cumulativeSeverity = 0.0;
    int? firstAlertMinute;
    double score = 0.0;

    final sessionEndTime =
        sessionStartTime.add(Duration(minutes: durationMinutes));
    DateTime currentTime = sessionStartTime;

    int nr = 0;

    while (currentTime.isBefore(sessionEndTime) ||
        currentTime.isAtSameMomentAs(sessionEndTime)) {
      final elapsedMinute = currentTime.difference(sessionStartTime).inMinutes;

      final alertsAtThisMinute = alertsByMinute[elapsedMinute];

      if (alertsAtThisMinute != null) {
        for (var alert in alertsAtThisMinute) {
          firstAlertMinute ??= elapsedMinute;
          cumulativeSeverity += alert.severity;
        }
      }

      if (firstAlertMinute == null) {
        score = 0.0;
      } else {
        final elapsedSeconds = (elapsedMinute - firstAlertMinute) * 60;
        if (elapsedSeconds > 0) {
          final adjustmentFactor = AdjustmentUtils.calculateAdjustmentFactor(
            elapsedSeconds: elapsedSeconds,
          );

          score = (cumulativeSeverity / elapsedSeconds) * adjustmentFactor;

          score = score.clamp(0.0, 1.0);
        } else {
          score = 0.0;
        }
      }

      appLogger.d(
        '📊 Score Point [$nr]: time=${currentTime.toFormattedTime(context)} | alerts=${alertsAtThisMinute?.length ?? 0} | cumulativeSeverity=$cumulativeSeverity | score=$score',
      );

      points.add(
        AlertDensityPoint(
          nr: nr++,
          density: score,
          alertType:
              alertsAtThisMinute?.map((a) => a.type).join(', ') ?? 'None',
          alertTime: currentTime.toFormattedTime(context),
          timeLabel: '${elapsedMinute}min',
          minute: elapsedMinute,
        ),
      );

      currentTime = currentTime.add(Duration(seconds: stepInSeconds));
    }

    appLogger.i('✅ Score Points Generated: ${points.length}');
    return points;
  }
}
