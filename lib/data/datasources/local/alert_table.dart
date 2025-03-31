import 'package:drift/drift.dart';
import 'session_report_table.dart'; 

class AlertTable extends Table {
  TextColumn get id => text()();
  TextColumn get type => text()();
  DateTimeColumn get timestamp => dateTime()();
  RealColumn get severity => real()();
  TextColumn get reportId => text().references(SessionReportTable, #id)();

  @override
  Set<Column> get primaryKey => {id};
}
