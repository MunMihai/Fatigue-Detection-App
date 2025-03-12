import 'alert_model.dart';
import 'package:driver_monitoring/domain/entities/session_report.dart';

class SessionReportModel {
  final String id;
  final DateTime timestamp;  // Un singur atribut de tip DateTime
  final int durationMinutes;
  final double averageSeverity;
  final String camera;
  final int retentionMonths;
  final List<AlertModel> alerts;

  SessionReportModel({
    required this.id,
    required this.timestamp,
    required this.durationMinutes,
    required this.averageSeverity,
    required this.camera,
    required this.retentionMonths,
    required this.alerts,
  });

  factory SessionReportModel.fromJson(
    Map<String, dynamic> json,
    List<AlertModel> alerts,
  ) {
    return SessionReportModel(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),  // Dacă este stocat ca string
      durationMinutes: json['durationMinutes'],
      averageSeverity: (json['averageSeverity'] as num).toDouble(),
      camera: json['camera'],
      retentionMonths: json['retentionMonths'],
      alerts: alerts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),  // Convertim DateTime în string
      'durationMinutes': durationMinutes,
      'averageSeverity': averageSeverity,
      'camera': camera,
      'retentionMonths': retentionMonths,
      // alerts se salvează separat
    };
  }

  SessionReport toEntity() {
    return SessionReport(
      id: id,
      timestamp: timestamp,
      durationMinutes: durationMinutes,
      averageSeverity: averageSeverity,
      camera: camera,
      retentionMonths: retentionMonths,
      alerts: alerts.map((e) => e.toEntity()).toList(),
    );
  }

  factory SessionReportModel.fromEntity(SessionReport entity) {
    return SessionReportModel(
      id: entity.id,
      timestamp: entity.timestamp,
      durationMinutes: entity.durationMinutes,
      averageSeverity: entity.averageSeverity,
      camera: entity.camera,
      retentionMonths: entity.retentionMonths,
      alerts: entity.alerts.map((e) => AlertModel.fromEntity(e, entity.id)).toList(),
    );
  }
}
