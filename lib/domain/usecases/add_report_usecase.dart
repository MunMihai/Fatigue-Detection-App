import '../entities/session_report.dart';
import '../repositories/session_report_repository.dart';

class AddReportUseCase {
  final SessionReportRepository repository;

  AddReportUseCase(this.repository);

  Future<void> call(SessionReport report) async {
    await repository.addReport(report);
  }
}
