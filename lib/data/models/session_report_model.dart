import 'package:drift/drift.dart';
import 'package:driver_monitoring/data/datasources/local/app_database.dart';
import 'package:driver_monitoring/data/models/alert_model.dart';
import 'package:driver_monitoring/domain/entities/session_report.dart';

class SessionReportModel {
  final String id;
  final DateTime timestamp;
  final int durationMinutes;
  final double averageSeverity;
  final int retentionMonths;
  final DateTime expirationDate; // noul câmp
  final List<AlertModel> alerts;

  SessionReportModel({
    required this.id,
    required this.timestamp,
    required this.durationMinutes,
    required this.averageSeverity,
    required this.retentionMonths,
    required this.expirationDate,
    required this.alerts,
  });

  // Actualizează metoda fromJson dacă este cazul
  factory SessionReportModel.fromJson(
    Map<String, dynamic> json,
    List<AlertModel> alerts,
  ) {
    return SessionReportModel(
      id: json['id'],
      timestamp: DateTime.parse(json['timestamp']),
      durationMinutes: json['durationMinutes'],
      averageSeverity: (json['averageSeverity'] as num).toDouble(),
      retentionMonths: json['retentionMonths'],
      expirationDate: DateTime.parse(json['expirationDate']),
      alerts: alerts,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'durationMinutes': durationMinutes,
      'averageSeverity': averageSeverity,
      'retentionMonths': retentionMonths,
      'expirationDate': expirationDate.toIso8601String(),
    };
  }

  // În metoda fromEntity, calculezi expirationDate în funcție de timestamp și retentionMonths
  factory SessionReportModel.fromEntity(SessionReport entity) {
    // De exemplu, folosind 30 de zile pentru o lună (poți ajusta după nevoi)
    final expirationDate = entity.timestamp.add(Duration(days: entity.retentionMonths * 30));
    return SessionReportModel(
      id: entity.id,
      timestamp: entity.timestamp,
      durationMinutes: entity.durationMinutes,
      averageSeverity: entity.averageSeverity,
      retentionMonths: entity.retentionMonths,
      expirationDate: expirationDate,
      alerts: entity.alerts
          .map((e) => AlertModel.fromEntity(e, entity.id))
          .toList(),
    );
  }

  SessionReport toEntity() {
    return SessionReport(
      id: id,
      timestamp: timestamp,
      durationMinutes: durationMinutes,
      averageSeverity: averageSeverity,
      retentionMonths: retentionMonths,
      alerts: alerts.map((e) => e.toEntity()).toList(),
    );
  }

  // 🔥 DRIFT MAPPER 🔥
  /// Model -> Drift Companion (pentru INSERT / UPDATE)
  SessionReportTableCompanion toCompanion() {
    return SessionReportTableCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      durationMinutes: Value(durationMinutes),
      averageSeverity: Value(averageSeverity),
      retentionMonths: Value(retentionMonths),
      expirationDate: Value(expirationDate),
    );
  }

  factory SessionReportModel.fromDrift(
    SessionReportTableData data,
    List<AlertModel> alerts,
  ) {
    return SessionReportModel(
      id: data.id,
      timestamp: data.timestamp,
      durationMinutes: data.durationMinutes,
      averageSeverity: data.averageSeverity,
      retentionMonths: data.retentionMonths,
      expirationDate: data.expirationDate, // noul câmp
      alerts: alerts,
    );
  }
}
