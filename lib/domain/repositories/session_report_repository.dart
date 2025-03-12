import '../entities/session_report.dart';

abstract class SessionReportRepository {
  Future<List<SessionReport>> getReports();
  Future<void> addReport(SessionReport report);
  Future<void> updateReport(SessionReport report);
  Future<void> deleteReport(String id);
}
