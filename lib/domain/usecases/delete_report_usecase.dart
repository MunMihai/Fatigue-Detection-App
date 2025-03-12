import '../repositories/session_report_repository.dart';

class DeleteReportUseCase {
  final SessionReportRepository repository;

  DeleteReportUseCase(this.repository);

  Future<void> call(String id) async {
    await repository.deleteReport(id);
  }
}
