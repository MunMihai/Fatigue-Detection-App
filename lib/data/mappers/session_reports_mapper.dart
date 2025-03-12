import 'package:driver_monitoring/domain/entities/session_report.dart';
import 'package:driver_monitoring/data/models/session_report_model.dart';
import 'alert_mapper.dart';

extension SessionReportMapper on SessionReport {
  SessionReportModel toModel() {
    return SessionReportModel(
      id: id,
      timestamp: timestamp, 
      durationMinutes: durationMinutes,
      averageSeverity: averageSeverity,
      camera: camera,
      retentionMonths: retentionMonths,
      alerts: alerts.map((alert) => alert.toModel(reportId: id)).toList(),
    );
  }
}

extension SessionReportModelMapper on SessionReportModel {
  SessionReport toEntity() {
    return SessionReport(
      id: id,
      timestamp: timestamp, 
      durationMinutes: durationMinutes,
      averageSeverity: averageSeverity,
      camera: camera,
      retentionMonths: retentionMonths,
      alerts: alerts.map((alertModel) => alertModel.toEntity()).toList(),
    );
  }
}
