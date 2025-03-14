import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:driver_monitoring/data/datasources/local/alert_table.dart';
import 'package:driver_monitoring/data/datasources/local/session_report_table.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;


part 'app_database.g.dart';

@DriftDatabase(tables: [AlertTable, SessionReportTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'driver_monitoring.sqlite'));
    return NativeDatabase(file);
  });
}
