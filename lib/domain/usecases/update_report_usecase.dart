import '../entities/session_report.dart';
import '../repositories/session_report_repository.dart';

class UpdateReportUseCase {
  final SessionReportRepository repository;

  UpdateReportUseCase(this.repository);

  Future<void> call(SessionReport report) async {
    await repository.updateReport(report);
  }
}
