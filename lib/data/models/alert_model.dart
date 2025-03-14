import 'package:drift/drift.dart';

import '../datasources/local/app_database.dart'; // Drift Table imports
import 'package:driver_monitoring/domain/entities/alert.dart';

class AlertModel {
  final String id;
  final String type;
  final DateTime timestamp;
  final double severity;
  final String reportId;

  AlertModel({
    required this.id,
    required this.type,
    required this.timestamp,
    required this.severity,
    required this.reportId,
  });

  /// JSON -> AlertModel
  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'],
      type: json['type'],
      timestamp: DateTime.parse(json['timestamp']),
      severity: (json['severity'] as num).toDouble(),
      reportId: json['reportId'],
    );
  }

  /// AlertModel -> JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'timestamp': timestamp.toIso8601String(),
      'severity': severity,
      'reportId': reportId,
    };
  }

  /// Entity -> Model
  factory AlertModel.fromEntity(Alert entity, String reportId) {
    return AlertModel(
      id: entity.id,
      type: entity.type,
      timestamp: entity.timestamp,
      severity: entity.severity,
      reportId: reportId,
    );
  }

  /// Model -> Entity
  Alert toEntity() {
    return Alert(
      id: id,
      type: type,
      timestamp: timestamp,
      severity: severity,
    );
  }

  // 🔥🔥🔥 DRIFT MAPPER DIRECT AICI 🔥🔥🔥

  /// Model -> Drift Companion (INSERT / UPDATE)
  AlertTableCompanion toCompanion() {
    return AlertTableCompanion(
      id: Value(id),
      type: Value(type),
      timestamp: Value(timestamp),
      severity: Value(severity),
      reportId: Value(reportId),
    );
  }

  /// Drift Row -> Model
  factory AlertModel.fromDrift(AlertTableData data) {
    return AlertModel(
      id: data.id,
      type: data.type,
      timestamp: data.timestamp,
      severity: data.severity,
      reportId: data.reportId,
    );
  }
}
