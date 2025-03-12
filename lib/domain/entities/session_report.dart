import 'alert.dart';
import 'package:driver_monitoring/domain/enum/fatigue_level.dart';

class SessionReport {
  final String id;
  final DateTime timestamp; 
  final int durationMinutes;
  final double averageSeverity;
  final String camera;
  final int retentionMonths;
  final List<Alert> alerts;

  SessionReport({
    required this.id,
    required this.timestamp,
    required this.durationMinutes,
    required this.averageSeverity,
    required this.camera,
    required this.retentionMonths,
    required this.alerts,
  });

  FatigueLevel get fatigueLevel => FatigueLevelExtension.fromScore(averageSeverity);
  String get fatigueLevelLabel => fatigueLevel.label; 
}
