import 'package:drift/drift.dart';
import 'package:driver_monitoring/data/datasources/session_report_datasource.dart';
import 'package:driver_monitoring/data/models/session_report_model.dart';
import 'package:driver_monitoring/data/datasources/local/app_database.dart';
import 'package:driver_monitoring/data/models/alert_model.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';

class DriftSessionReportLocalDataSource implements SessionReportDataSource {
  final AppDatabase db;

  DriftSessionReportLocalDataSource(this.db);

  @override
  Future<List<SessionReportModel>> getReports() async {
    appLogger.i('📥 Fetching reports from Drift DB...');

    final reportsRows = await db.select(db.sessionReportTable).get();

    final List<SessionReportModel> reports = [];

    for (final report in reportsRows) {
      final alertsRows = await (db.select(db.alertTable)
            ..where((alert) => alert.reportId.equals(report.id)))
          .get();

      final alerts =
          alertsRows.map((alertRow) => AlertModel.fromDrift(alertRow)).toList();

      reports.add(SessionReportModel.fromDrift(report, alerts));
    }

    appLogger.i('✅ Retrieved ${reports.length} reports from Drift DB.');
    return reports;
  }

  @override
  Future<void> addReport(SessionReportModel report) async {
    appLogger.i('➕ Adding report with id: ${report.id} to Drift DB...');

    await db.into(db.sessionReportTable).insert(report.toCompanion());

    for (final alert in report.alerts) {
      await db.into(db.alertTable).insert(alert.toCompanion());
    }

    appLogger.i('✅ Report with id: ${report.id} added to Drift DB.');
  }

  @override
  Future<void> updateReport(SessionReportModel report) async {
    appLogger.i('✏️ Updating report with id: ${report.id}...');

    await db.update(db.sessionReportTable).replace(report.toCompanion());

    await (db.delete(db.alertTable)
          ..where((alert) => alert.reportId.equals(report.id)))
        .go();

    for (final alert in report.alerts) {
      await db.into(db.alertTable).insert(alert.toCompanion());
    }

    appLogger.i('✅ Report with id: ${report.id} updated in Drift DB.');
  }

  @override
  Future<void> deleteReport(String id) async {
    appLogger.i('🗑️ Deleting report with id: $id from Drift DB...');

    await (db.delete(db.alertTable)
          ..where((alert) => alert.reportId.equals(id)))
        .go();

    await (db.delete(db.sessionReportTable)
          ..where((report) => report.id.equals(id)))
        .go();

    appLogger.i('✅ Report with id: $id deleted from Drift DB.');
  }

  @override
  Future<void> deleteExpiredReports(DateTime currentDate) async {
    final expiredReports = await (db.select(db.sessionReportTable)
          ..where((tbl) => tbl.expirationDate.isSmallerThanValue(currentDate)))
        .get();

    for (final report in expiredReports) {
      await deleteReport(report.id);
    }
  }
}
