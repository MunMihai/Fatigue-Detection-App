import 'package:drift/drift.dart';

import 'alert_model.dart';
import '../datasources/local/app_database.dart'; // Drift Table imports
import 'package:driver_monitoring/domain/entities/session_report.dart';

class SessionReportModel {
  final String id;
  final DateTime timestamp;
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

  // ✅ JSON -> Model
  factory SessionReportModel.fromJson(
    Map<String, dynamic> json,
    List<AlertModel> alerts,
  ) {
    return SessionReportModel(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      durationMinutes: json['durationMinutes'],
      averageSeverity: (json['averageSeverity'] as num).toDouble(),
      camera: json['camera'],
      retentionMonths: json['retentionMonths'],
      alerts: alerts,
    );
  }

  // ✅ Model -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'durationMinutes': durationMinutes,
      'averageSeverity': averageSeverity,
      'camera': camera,
      'retentionMonths': retentionMonths,
    };
  }

  // ✅ Entity -> Model
  factory SessionReportModel.fromEntity(SessionReport entity) {
    return SessionReportModel(
      id: entity.id,
      timestamp: entity.timestamp,
      durationMinutes: entity.durationMinutes,
      averageSeverity: entity.averageSeverity,
      camera: entity.camera,
      retentionMonths: entity.retentionMonths,
      alerts: entity.alerts
          .map((e) => AlertModel.fromEntity(e, entity.id))
          .toList(),
    );
  }

  // ✅ Model -> Entity
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

  // 🔥🔥🔥 DRIFT MAPPER 🔥🔥🔥

  /// Model -> Drift Companion (INSERT / UPDATE)
  SessionReportTableCompanion toCompanion() {
    return SessionReportTableCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      durationMinutes: Value(durationMinutes),
      averageSeverity: Value(averageSeverity),
      camera: Value(camera),
      retentionMonths: Value(retentionMonths),
    );
  }

  /// Drift Row -> Model
  factory SessionReportModel.fromDrift(
    SessionReportTableData data,
    List<AlertModel> alerts,
  ) {
    return SessionReportModel(
      id: data.id,
      timestamp: data.timestamp,
      durationMinutes: data.durationMinutes,
      averageSeverity: data.averageSeverity,
      camera: data.camera,
      retentionMonths: data.retentionMonths,
      alerts: alerts,
    );
  }
}
