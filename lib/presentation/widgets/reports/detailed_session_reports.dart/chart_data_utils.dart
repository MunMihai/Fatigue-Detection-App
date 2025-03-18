import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/core/utils/date_time_extension.dart';
import 'package:driver_monitoring/domain/entities/alert.dart';
import 'package:driver_monitoring/domain/entities/alert_density_point.dart';

class ChartDataUtils {
  static List<AlertDensityPoint> buildControlPoints(
    List<Alert> sortedAlerts,
    DateTime sessionStartTime,
    int durationMinutes,
  ) {
    final controlPoints = <AlertDensityPoint>[];

    controlPoints.add(
      AlertDensityPoint(
        nr: 0,
        density: 0,
        alertType: 'Start',
        alertTime: sessionStartTime.toFormattedTime(),
        timeLabel: '0min',
        minute: 0,
      ),
    );

    double cumulativeSeverity = 0;

    for (int i = 0; i < sortedAlerts.length; i++) {
      final alert = sortedAlerts[i];
      final elapsedMinutes =
          alert.timestamp.difference(sessionStartTime).inMinutes;

      cumulativeSeverity += alert.severity;

      // 🔸 Densitatea pe minut: severitate cumulată raportată la timp
      final double density = elapsedMinutes > 0
          ? cumulativeSeverity / elapsedMinutes
          : cumulativeSeverity;

      appLogger.d(
          '🚀 Density point [$i]: severity=$cumulativeSeverity, time=$elapsedMinutes min, density=$density');

      controlPoints.add(
        AlertDensityPoint(
          nr: i + 1,
          density: density,
          alertType: alert.type,
          alertTime: alert.timestamp.toFormattedTime(),
          timeLabel: '${elapsedMinutes}min',
          minute: elapsedMinutes,
        ),
      );
    }

    final double finalDensity =
        durationMinutes > 0 ? cumulativeSeverity / durationMinutes : 0;

    controlPoints.add(
      AlertDensityPoint(
        nr: sortedAlerts.length,
        density: finalDensity,
        alertType: 'End',
        alertTime: sessionStartTime
            .add(Duration(minutes: durationMinutes))
            .toFormattedTime(),
        timeLabel: '${durationMinutes}min',
        minute: durationMinutes,
      ),
    );

    return controlPoints;
  }

  static List<AlertDensityPoint> generateLinearPoints(
    List<AlertDensityPoint> controlPoints,
    DateTime sessionStartTime,
  ) {
    final result = <AlertDensityPoint>[];

    for (int i = 0; i < controlPoints.length - 1; i++) {
      final current = controlPoints[i];
      final next = controlPoints[i + 1];

      final int minuteStart = current.minute;
      final int minuteEnd = next.minute;

      const int step = 1;

      for (int m = minuteStart; m < minuteEnd; m += step) {
        final double t = (m - minuteStart) / (minuteEnd - minuteStart);

        final double interpolatedDensity =
            _lerp(current.density, next.density, t);
        final int interpolatedNr = _lerpInt(current.nr, next.nr, t);

        result.add(
          AlertDensityPoint(
            nr: interpolatedNr,
            density: interpolatedDensity,
            alertType: current.alertType,
            alertTime:
                sessionStartTime.add(Duration(minutes: m)).toFormattedTime(),
            timeLabel: '${m}min',
            minute: m,
          ),
        );
      }
    }

    result.add(controlPoints.last);

    return result;
  }

  static double _lerp(double a, double b, double t) => a + (b - a) * t;
  static int _lerpInt(int a, int b, double t) => (a + (b - a) * t).round();
}
