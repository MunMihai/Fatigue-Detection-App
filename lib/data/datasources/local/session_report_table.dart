import 'package:drift/drift.dart';

class SessionReportTable extends Table {
  TextColumn get id => text()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get durationMinutes => integer()();
  RealColumn get averageSeverity => real()();
  TextColumn get camera => text()();
  IntColumn get retentionMonths => integer()();

  @override
  Set<Column> get primaryKey => {id};
}
