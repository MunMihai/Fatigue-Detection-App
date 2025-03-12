import 'package:driver_monitoring/core/utils/date_time_extension.dart';
import 'package:flutter/material.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/domain/entities/session_report.dart';
import 'package:driver_monitoring/domain/usecases/get_reports_usecase.dart';
import 'package:driver_monitoring/domain/usecases/add_report_usecase.dart';
import 'package:driver_monitoring/domain/usecases/update_report_usecase.dart';
import 'package:driver_monitoring/domain/usecases/delete_report_usecase.dart';

class SessionReportProvider with ChangeNotifier {
  final GetReportsUseCase getReportsUseCase;
  final AddReportUseCase addReportUseCase;
  final UpdateReportUseCase updateReportUseCase;
  final DeleteReportUseCase deleteReportUseCase;

  List<SessionReport> _reports = [];
  bool _isLoading = false;

  String _searchQuery = '';
  bool _sortAsc = false;

  List<SessionReport> get reports => _reports;
  bool get isLoading => _isLoading;
  String get searchQuery => _searchQuery;
  bool get sortAsc => _sortAsc;

  SessionReportProvider({
    required this.getReportsUseCase,
    required this.addReportUseCase,
    required this.updateReportUseCase,
    required this.deleteReportUseCase,
  });

  Future<void> fetchReports() async {
    _isLoading = true;
    notifyListeners();

    try {
      _reports = await getReportsUseCase();
      appLogger.i('Reports fetched successfully');
    } catch (e, stackTrace) {
      appLogger.e('Error fetching reports', error: e, stackTrace: stackTrace);
      _reports = [];
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addReport(SessionReport report) async {
    _isLoading = true;
    notifyListeners();

    try {
      await addReportUseCase(report);
      await fetchReports();
      appLogger.i('Report added: ${report.id}');
    } catch (e, stackTrace) {
      appLogger.e('Error adding report', error: e, stackTrace: stackTrace);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateReport(SessionReport report) async {
    _isLoading = true;
    notifyListeners();

    try {
      await updateReportUseCase(report);
      await fetchReports();
      appLogger.i('Report updated: ${report.id}');
    } catch (e, stackTrace) {
      appLogger.e('Error updating report', error: e, stackTrace: stackTrace);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteReport(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await deleteReportUseCase(id);
      await fetchReports();
      appLogger.i('Report deleted: $id');
    } catch (e, stackTrace) {
      appLogger.e('Error deleting report', error: e, stackTrace: stackTrace);
    }

    _isLoading = false;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    appLogger.d('Search query set to: $_searchQuery');
    notifyListeners();
  }

  void resetSearchQuery() {
    _searchQuery = '';
    appLogger.d('Search query reset');
    notifyListeners();
  }

  void toggleSortOrder() {
    _sortAsc = !_sortAsc;
    appLogger.d('Sort order toggled. Ascending: $_sortAsc');
    notifyListeners();
  }

  List<SessionReport> get filteredAndSortedReports {
    var filtered = _reports.where((session) {
      final query = _searchQuery.toLowerCase();
      return session.timestamp.toIso8601String().contains(query) ||
          session.timestamp.toFormattedDate().contains(query) ||
          session.fatigueLevelLabel.toLowerCase().contains(query);
    }).toList();

    filtered.sort((a, b) => _sortAsc
        ? a.timestamp.compareTo(b.timestamp)
        : b.timestamp.compareTo(a.timestamp));

    return filtered;
  }

  Future<void> refreshReports() async {
    await fetchReports();
  }
}
