import '../models/session_report_model.dart';

abstract class SessionReportDataSource {
  Future<List<SessionReportModel>> getReports();
  Future<void> addReport(SessionReportModel report);
  Future<void> updateReport(SessionReportModel report);
  Future<void> deleteReport(String id);
}
