class AlertDensityPoint {
  final int nr;
  final double density;
  final String alertType;
  final String alertTime;
  final String timeLabel;
  final int minute;

  AlertDensityPoint({
    required this.nr,
    required this.density,
    required this.alertType,
    required this.alertTime,
    required this.timeLabel,
    required this.minute,
  });
}
