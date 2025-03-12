import '../entities/session_report.dart';
import '../repositories/session_report_repository.dart';

class GetReportsUseCase {
  final SessionReportRepository repository;

  GetReportsUseCase(this.repository);

  Future<List<SessionReport>> call() async {
    return await repository.getReports();
  }
}
