import 'package:driver_monitoring/data/datasources/session_report_datasource.dart';
import 'package:driver_monitoring/data/mappers/session_reports_mapper.dart';
import 'package:driver_monitoring/domain/entities/session_report.dart';
import 'package:driver_monitoring/domain/repositories/session_report_repository.dart';

class SessionReportRepositoryImpl implements SessionReportRepository {
  final SessionReportDataSource dataSource;

  const SessionReportRepositoryImpl({
    required this.dataSource,
  });

  @override
  Future<List<SessionReport>> getReports() async {
    final reportModels = await dataSource.getReports();
    return reportModels.map((model) => model.toEntity()).toList();
  }

  @override
  Future<void> addReport(SessionReport report) async {
    final model = report.toModel();
    await dataSource.addReport(model);
  }

  @override
  Future<void> updateReport(SessionReport report) async {
    final model = report.toModel();
    await dataSource.updateReport(model);
  }

  @override
  Future<void> deleteReport(String id) async {
    await dataSource.deleteReport(id);
  }
}
