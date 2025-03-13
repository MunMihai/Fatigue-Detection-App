import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/core/utils/date_time_extension.dart';
import 'package:driver_monitoring/domain/entities/session_report.dart';
import 'package:driver_monitoring/domain/usecases/add_report_usecase.dart';
import 'package:driver_monitoring/domain/usecases/delete_report_usecase.dart';
import 'package:driver_monitoring/domain/usecases/get_reports_usecase.dart';
import 'package:driver_monitoring/domain/usecases/update_report_usecase.dart';
import 'package:flutter/widgets.dart';

class SessionReportProvider with ChangeNotifier {
  final GetReportsUseCase getReportsUseCase;
  final AddReportUseCase addReportUseCase;
  final UpdateReportUseCase updateReportUseCase;
  final DeleteReportUseCase deleteReportUseCase;

  List<SessionReport> _reports = [];
  bool _isLoading = false;

  String _searchQuery = '';
  bool _sortAsc = false;

  // ✅ Nou flag care indică dacă s-au descărcat rapoartele
  bool _hasFetchedReports = false;
  bool get hasFetchedReports => _hasFetchedReports;

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

  /// ✅ Fetch + flag de control
  Future<void> fetchReports() async {
    if (_hasFetchedReports) return; // 🔥 Dacă am mai făcut fetch, nu mai apelăm încă o dată

    _isLoading = true;
    notifyListeners();

    try {
      _reports = await getReportsUseCase();
      _hasFetchedReports = true; // ✅ Marcam că am făcut fetch
      appLogger.i('Reports fetched successfully');
    } catch (e, stackTrace) {
      appLogger.e('Error fetching reports', error: e, stackTrace: stackTrace);
      _reports = [];
      _hasFetchedReports = false;
    }

    _isLoading = false;
    notifyListeners();
  }

  /// ✅ Resetează lista de rapoarte și flag-ul de fetch
  void clearReports() {
    _reports = [];
    _hasFetchedReports = false; // Resetăm pentru a putea refetch-ui dacă e cazul
    notifyListeners();
    appLogger.d('Reports cleared');
  }

  Future<void> addReport(SessionReport report) async {
    _isLoading = true;
    notifyListeners();

    try {
      await addReportUseCase(report);
      _hasFetchedReports = false; // ⚠️ Resetăm flag-ul pentru a refetch-ui după adăugare
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
      _hasFetchedReports = false; // ⚠️ Resetăm flag-ul pentru a refetch-ui după update
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
      _hasFetchedReports = false; // ⚠️ Resetăm flag-ul pentru a refetch-ui după delete
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
          session.timestamp.toFormattedDate().toString().contains(query) ||
          session.fatigueLevelLabel.toLowerCase().contains(query);
    }).toList();

    filtered.sort((a, b) => _sortAsc
        ? a.timestamp.compareTo(b.timestamp)
        : b.timestamp.compareTo(a.timestamp));

    return filtered;
  }

  Future<void> refreshReports() async {
    _hasFetchedReports = false; // ✅ Resetăm flag-ul și refacem fetch-ul
    await fetchReports();
  }
}
