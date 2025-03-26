import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:driver_monitoring/data/datasources/session_report_datasource.dart';
import 'package:driver_monitoring/data/models/session_report_model.dart';
import 'package:driver_monitoring/data/models/alert_model.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';

class MockSessionReportLocalDataSource implements SessionReportDataSource {
  final List<SessionReportModel> _reports = [];

  /// Constructor - Inițializează clasa
  MockSessionReportLocalDataSource() {
    _loadMockData();
  }

  /// ✅ Încarcă datele din assets
  Future<void> _loadMockData() async {
    try {
      final reportsJsonString = await rootBundle.loadString('assets/mock/mock_session_reports.json');
      final alertsJsonString = await rootBundle.loadString('assets/mock/mock_alerts.json');

      final reportsJson = jsonDecode(reportsJsonString) as List<dynamic>;
      final alertsJson = jsonDecode(alertsJsonString) as List<dynamic>;

      _reports.clear();

      for (final reportMap in reportsJson) {
        final reportId = reportMap['id'];

        final relatedAlerts = alertsJson
            .where((alert) => alert['reportId'] == reportId)
            .map((alert) => AlertModel.fromJson(alert))
            .toList();

        final report = SessionReportModel.fromJson(reportMap, relatedAlerts);
        _reports.add(report);
      }

      appLogger.i('✅ Loaded ${_reports.length} reports from assets JSON files.');
    } catch (e, stackTrace) {
      appLogger.e('❌ Error loading mock data', error: e, stackTrace: stackTrace);
    }
  }

  @override
  Future<List<SessionReportModel>> getReports() async {
    await Future.delayed(const Duration(milliseconds: 300));
    appLogger.i('📥 Fetching ${_reports.length} reports...');
    return List<SessionReportModel>.from(_reports);
  }

  @override
  Future<void> addReport(SessionReportModel report) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _reports.add(report);
    appLogger.i('➕ Added report with id: ${report.id}');
  }

  @override
  Future<void> updateReport(SessionReportModel report) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _reports.indexWhere((r) => r.id == report.id);
    if (index != -1) {
      _reports[index] = report;
      appLogger.i('✏️ Updated report with id: ${report.id}');
    } else {
      appLogger.w('⚠️ Tried to update a non-existing report with id: ${report.id}');
    }
  }

  @override
  Future<void> deleteReport(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));

    final exists = _reports.any((r) => r.id == id);

    if (exists) {
      _reports.removeWhere((r) => r.id == id);
      appLogger.i('🗑️ Deleted report with id: $id');
    } else {
      appLogger.w('⚠️ Tried to delete a non-existing report with id: $id');
    }
  }
  
  @override
  Future<void> deleteExpiredReports(DateTime currentDate) {
    // TODO: implement deleteExpiredReports
    throw UnimplementedError();
  }
}
