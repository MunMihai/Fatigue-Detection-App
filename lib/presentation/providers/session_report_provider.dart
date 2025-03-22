import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/domain/entities/session_report.dart';
import 'package:driver_monitoring/domain/usecases/add_report_usecase.dart';
import 'package:driver_monitoring/domain/usecases/delete_report_usecase.dart';
import 'package:driver_monitoring/domain/usecases/get_reports_usecase.dart';
import 'package:driver_monitoring/domain/usecases/update_report_usecase.dart';
import 'package:flutter/foundation.dart';

class SessionReportProvider with ChangeNotifier {
  final GetReportsUseCase getReportsUseCase;
  final AddReportUseCase addReportUseCase;
  final UpdateReportUseCase updateReportUseCase;
  final DeleteReportUseCase deleteReportUseCase;

  List<SessionReport> _reports = [];
  bool _isLoading = false;
  bool _hasFetchedReports = false;

  bool get hasFetchedReports => _hasFetchedReports;
  bool get isLoading => _isLoading;
  List<SessionReport> get reports => _reports;

  SessionReportProvider({
    required this.getReportsUseCase,
    required this.addReportUseCase,
    required this.updateReportUseCase,
    required this.deleteReportUseCase,
  });
  Future<void> fetchReports() async {
    if (_hasFetchedReports) return;

    _isLoading = true;
    notifyListeners();

    try {
      _reports = await getReportsUseCase();
      _hasFetchedReports = true;
      appLogger.i('✅ Reports fetched successfully');
    } catch (e, stackTrace) {
      appLogger.e('❌ Error fetching reports', error: e, stackTrace: stackTrace);
      _reports = [];
      _hasFetchedReports = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearReports() {
    _reports.clear();
    _hasFetchedReports = false;
    notifyListeners();
    appLogger.d('🗑️ Reports cleared');
  }

  Future<void> addReport(SessionReport report) async {
    _isLoading = true;
    notifyListeners();

    try {
      await addReportUseCase(report);
      _hasFetchedReports = false;
      appLogger.i('➕ Report added: ${report.id}');
    } catch (e, stackTrace) {
      appLogger.e('❌ Error adding report', error: e, stackTrace: stackTrace);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateReport(SessionReport report) async {
    _isLoading = true;
    notifyListeners();

    try {
      await updateReportUseCase(report);
      _hasFetchedReports = false;
      await fetchReports();
      appLogger.i('✏️ Report updated: ${report.id}');
    } catch (e, stackTrace) {
      appLogger.e('❌ Error updating report', error: e, stackTrace: stackTrace);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteReport(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await deleteReportUseCase(id);
      _hasFetchedReports = false;
      await fetchReports();
      appLogger.i('🗑️ Report deleted: $id');
    } catch (e, stackTrace) {
      appLogger.e('❌ Error deleting report', error: e, stackTrace: stackTrace);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refreshReports() async {
    _hasFetchedReports = false;
    await fetchReports();
  }
}
