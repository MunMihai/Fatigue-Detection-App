import 'package:driver_monitoring/domain/entities/alert_density_point.dart';
import 'package:driver_monitoring/core/enum/fatigue_level.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';

class AlertDensityChart extends StatelessWidget {
  final List<AlertDensityPoint> points;

  const AlertDensityChart({
    super.key,
    required this.points,
  });

  @override
  Widget build(BuildContext context) {
    final double maxDensity = points.isNotEmpty
        ? points.map((e) => e.density).reduce((a, b) => a > b ? a : b)
        : 1.0;

    // Adaugi un mic offset ca să nu fie fix la limită.
    final double yAxisMax = (maxDensity * 1.1).clamp(0, 1.0);

    return SizedBox(
      height: 300,
      child: SfCartesianChart(
        title: ChartTitle(
          text: 'Fatigue Score Over Time',
          textStyle: AppTextStyles.h2,
          alignment: ChartAlignment.near,
        ),
        primaryXAxis: CategoryAxis(
          labelRotation: -45,
          labelStyle: AppTextStyles.medium_12,
          rangePadding: ChartRangePadding.none,
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          interval: yAxisMax / 10,
          maximum: yAxisMax,
          title: AxisTitle(text: 'Fatigue Score'),
          isVisible: false,
        ),
        tooltipBehavior: TooltipBehavior(
          enable: true,
          activationMode: ActivationMode.singleTap,
          canShowMarker: true,
          tooltipPosition: TooltipPosition.pointer,
          builder: (dynamic data, dynamic point, dynamic series, int pointIndex,
              int seriesIndex) {
            final AlertDensityPoint alertPoint = data as AlertDensityPoint;
            final fatigueLevel =
                FatigueLevelExtension.fromScore(alertPoint.density);
            return Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: fatigueLevel.color(context),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${alertPoint.timeLabel}\n${alertPoint.nr}: ${alertPoint.alertType}\nAt: ${alertPoint.alertTime}\nLevel: ${fatigueLevel.label}\nScore: ${alertPoint.density.toStringAsFixed(4)}',
                style: AppTextStyles.medium_12.copyWith(color: Colors.white),
              ),
            );
          },
        ),
        zoomPanBehavior: ZoomPanBehavior(
          enablePinching: true,
          enablePanning: true,
          zoomMode: ZoomMode.xy,
          enableDoubleTapZooming: true,
        ),
        legend: Legend(isVisible: false),

        /// ✅ AreaSeries cu gradient de oboseală
        series: <CartesianSeries<AlertDensityPoint, String>>[
          AreaSeries<AlertDensityPoint, String>(
            dataSource: points,
            xValueMapper: (AlertDensityPoint point, _) => point.alertTime,
            yValueMapper: (AlertDensityPoint point, _) => point.density,
            gradient: _buildFatigueGradient(context),
            borderWidth: 0,
            animationDuration: 1500,
          ),
        ],
      ),
    );
  }

  LinearGradient _buildFatigueGradient(BuildContext context) {
    final colors = points.isEmpty
        ? [Colors.grey, Colors.grey]
        : points
            .map((point) =>
                FatigueLevelExtension.fromScore(point.density).color(context))
            .toList();

    final stops = points.isEmpty ? [0.0, 1.0] : _generateStops(points.length);

    return LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      colors: colors,
      stops: stops,
    );
  }

  List<double> _generateStops(int length) {
    if (length <= 1) {
      return [0.0, 1.0];
    }
    return List<double>.generate(length, (index) => index / (length - 1));
  }
}
