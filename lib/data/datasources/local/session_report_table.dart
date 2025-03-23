import 'package:drift/drift.dart';

class SessionReportTable extends Table {
  TextColumn get id => text()();
  DateTimeColumn get timestamp => dateTime()();
  IntColumn get durationMinutes => integer()();
  RealColumn get highestSeverityScore => real()();
  IntColumn get retentionMonths => integer()();
  DateTimeColumn get expirationDate => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

