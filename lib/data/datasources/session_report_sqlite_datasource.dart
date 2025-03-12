import 'package:driver_monitoring/data/datasources/session_report_datasource.dart';
import 'package:driver_monitoring/data/models/alert_model.dart';
import 'package:driver_monitoring/data/models/session_report_model.dart';
import 'package:sqflite/sqflite.dart';

class SessionReportSqliteDataSource implements SessionReportDataSource {
  final Database db;

  SessionReportSqliteDataSource(this.db);

  @override
  Future<List<SessionReportModel>> getReports() async {
    final List<Map<String, dynamic>> reportMaps =
        await db.query('session_reports');

    List<SessionReportModel> reports = [];

    for (final reportMap in reportMaps) {
      final List<Map<String, dynamic>> alertsMaps = await db.query(
        'alerts',
        where: 'reportId = ?',
        whereArgs: [reportMap['id']],
      );

      final alerts =
          alertsMaps.map((alertMap) => AlertModel.fromJson(alertMap)).toList();

      final report = SessionReportModel.fromJson(reportMap, alerts);
      reports.add(report);
    }

    return reports;
  }

  @override
  Future<void> addReport(SessionReportModel report) async {
    await db.transaction((txn) async {
      await txn.insert('session_reports', report.toJson());

      final batch = txn.batch();
      for (final alert in report.alerts) {
        batch.insert('alerts', alert.toJson());
      }
      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> updateReport(SessionReportModel report) async {
    await db.transaction((txn) async {
      await txn.update(
        'session_reports',
        report.toJson(),
        where: 'id = ?',
        whereArgs: [report.id],
      );

      // Ștergi alertele vechi înainte de a le adăuga pe cele noi
      await txn.delete('alerts', where: 'reportId = ?', whereArgs: [report.id]);

      final batch = txn.batch();
      for (final alert in report.alerts) {
        batch.insert('alerts', alert.toJson());
      }
      await batch.commit(noResult: true);
    });
  }

  @override
  Future<void> deleteReport(String id) async {
    await db.transaction((txn) async {
      await txn.delete('alerts', where: 'reportId = ?', whereArgs: [id]);
      await txn.delete('session_reports', where: 'id = ?', whereArgs: [id]);
    });
  }
}
