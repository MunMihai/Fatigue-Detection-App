import 'alert.dart';
import 'package:driver_monitoring/core/enum/fatigue_level.dart';

class SessionReport {
  final String id;
  final DateTime timestamp; 
  final int durationMinutes;
  final double averageSeverity;
  final int retentionMonths;
  final List<Alert> alerts;

  SessionReport({
    required this.id,
    required this.timestamp,
    required this.durationMinutes,
    required this.averageSeverity,
    required this.retentionMonths,
    required this.alerts,
  });

  FatigueLevel get fatigueLevel => FatigueLevelExtension.fromScore(averageSeverity);
  String get fatigueLevelLabel => fatigueLevel.label; 

   SessionReport copyWith({
    String? id,
    DateTime? timestamp,
    int? durationMinutes,
    double? averageSeverity,
    String? camera,
    int? retentionMonths,
    List<Alert>? alerts,
  }) {
    return SessionReport(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      averageSeverity: averageSeverity ?? this.averageSeverity,
      retentionMonths: retentionMonths ?? this.retentionMonths,
      alerts: alerts ?? this.alerts,
    );
  }

}
