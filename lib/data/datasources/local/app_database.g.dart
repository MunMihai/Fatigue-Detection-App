// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SessionReportTableTable extends SessionReportTable
    with TableInfo<$SessionReportTableTable, SessionReportTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SessionReportTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _durationMinutesMeta =
      const VerificationMeta('durationMinutes');
  @override
  late final GeneratedColumn<int> durationMinutes = GeneratedColumn<int>(
      'duration_minutes', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _averageSeverityMeta =
      const VerificationMeta('averageSeverity');
  @override
  late final GeneratedColumn<double> averageSeverity = GeneratedColumn<double>(
      'average_severity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _cameraMeta = const VerificationMeta('camera');
  @override
  late final GeneratedColumn<String> camera = GeneratedColumn<String>(
      'camera', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _retentionMonthsMeta =
      const VerificationMeta('retentionMonths');
  @override
  late final GeneratedColumn<int> retentionMonths = GeneratedColumn<int>(
      'retention_months', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        timestamp,
        durationMinutes,
        averageSeverity,
        camera,
        retentionMonths
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'session_report_table';
  @override
  VerificationContext validateIntegrity(
      Insertable<SessionReportTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('duration_minutes')) {
      context.handle(
          _durationMinutesMeta,
          durationMinutes.isAcceptableOrUnknown(
              data['duration_minutes']!, _durationMinutesMeta));
    } else if (isInserting) {
      context.missing(_durationMinutesMeta);
    }
    if (data.containsKey('average_severity')) {
      context.handle(
          _averageSeverityMeta,
          averageSeverity.isAcceptableOrUnknown(
              data['average_severity']!, _averageSeverityMeta));
    } else if (isInserting) {
      context.missing(_averageSeverityMeta);
    }
    if (data.containsKey('camera')) {
      context.handle(_cameraMeta,
          camera.isAcceptableOrUnknown(data['camera']!, _cameraMeta));
    } else if (isInserting) {
      context.missing(_cameraMeta);
    }
    if (data.containsKey('retention_months')) {
      context.handle(
          _retentionMonthsMeta,
          retentionMonths.isAcceptableOrUnknown(
              data['retention_months']!, _retentionMonthsMeta));
    } else if (isInserting) {
      context.missing(_retentionMonthsMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SessionReportTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SessionReportTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      durationMinutes: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}duration_minutes'])!,
      averageSeverity: attachedDatabase.typeMapping.read(
          DriftSqlType.double, data['${effectivePrefix}average_severity'])!,
      camera: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}camera'])!,
      retentionMonths: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}retention_months'])!,
    );
  }

  @override
  $SessionReportTableTable createAlias(String alias) {
    return $SessionReportTableTable(attachedDatabase, alias);
  }
}

class SessionReportTableData extends DataClass
    implements Insertable<SessionReportTableData> {
  final String id;
  final DateTime timestamp;
  final int durationMinutes;
  final double averageSeverity;
  final String camera;
  final int retentionMonths;
  const SessionReportTableData(
      {required this.id,
      required this.timestamp,
      required this.durationMinutes,
      required this.averageSeverity,
      required this.camera,
      required this.retentionMonths});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['duration_minutes'] = Variable<int>(durationMinutes);
    map['average_severity'] = Variable<double>(averageSeverity);
    map['camera'] = Variable<String>(camera);
    map['retention_months'] = Variable<int>(retentionMonths);
    return map;
  }

  SessionReportTableCompanion toCompanion(bool nullToAbsent) {
    return SessionReportTableCompanion(
      id: Value(id),
      timestamp: Value(timestamp),
      durationMinutes: Value(durationMinutes),
      averageSeverity: Value(averageSeverity),
      camera: Value(camera),
      retentionMonths: Value(retentionMonths),
    );
  }

  factory SessionReportTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SessionReportTableData(
      id: serializer.fromJson<String>(json['id']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      durationMinutes: serializer.fromJson<int>(json['durationMinutes']),
      averageSeverity: serializer.fromJson<double>(json['averageSeverity']),
      camera: serializer.fromJson<String>(json['camera']),
      retentionMonths: serializer.fromJson<int>(json['retentionMonths']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'durationMinutes': serializer.toJson<int>(durationMinutes),
      'averageSeverity': serializer.toJson<double>(averageSeverity),
      'camera': serializer.toJson<String>(camera),
      'retentionMonths': serializer.toJson<int>(retentionMonths),
    };
  }

  SessionReportTableData copyWith(
          {String? id,
          DateTime? timestamp,
          int? durationMinutes,
          double? averageSeverity,
          String? camera,
          int? retentionMonths}) =>
      SessionReportTableData(
        id: id ?? this.id,
        timestamp: timestamp ?? this.timestamp,
        durationMinutes: durationMinutes ?? this.durationMinutes,
        averageSeverity: averageSeverity ?? this.averageSeverity,
        camera: camera ?? this.camera,
        retentionMonths: retentionMonths ?? this.retentionMonths,
      );
  SessionReportTableData copyWithCompanion(SessionReportTableCompanion data) {
    return SessionReportTableData(
      id: data.id.present ? data.id.value : this.id,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      durationMinutes: data.durationMinutes.present
          ? data.durationMinutes.value
          : this.durationMinutes,
      averageSeverity: data.averageSeverity.present
          ? data.averageSeverity.value
          : this.averageSeverity,
      camera: data.camera.present ? data.camera.value : this.camera,
      retentionMonths: data.retentionMonths.present
          ? data.retentionMonths.value
          : this.retentionMonths,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SessionReportTableData(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('averageSeverity: $averageSeverity, ')
          ..write('camera: $camera, ')
          ..write('retentionMonths: $retentionMonths')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, timestamp, durationMinutes, averageSeverity, camera, retentionMonths);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SessionReportTableData &&
          other.id == this.id &&
          other.timestamp == this.timestamp &&
          other.durationMinutes == this.durationMinutes &&
          other.averageSeverity == this.averageSeverity &&
          other.camera == this.camera &&
          other.retentionMonths == this.retentionMonths);
}

class SessionReportTableCompanion
    extends UpdateCompanion<SessionReportTableData> {
  final Value<String> id;
  final Value<DateTime> timestamp;
  final Value<int> durationMinutes;
  final Value<double> averageSeverity;
  final Value<String> camera;
  final Value<int> retentionMonths;
  final Value<int> rowid;
  const SessionReportTableCompanion({
    this.id = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.durationMinutes = const Value.absent(),
    this.averageSeverity = const Value.absent(),
    this.camera = const Value.absent(),
    this.retentionMonths = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SessionReportTableCompanion.insert({
    required String id,
    required DateTime timestamp,
    required int durationMinutes,
    required double averageSeverity,
    required String camera,
    required int retentionMonths,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        timestamp = Value(timestamp),
        durationMinutes = Value(durationMinutes),
        averageSeverity = Value(averageSeverity),
        camera = Value(camera),
        retentionMonths = Value(retentionMonths);
  static Insertable<SessionReportTableData> custom({
    Expression<String>? id,
    Expression<DateTime>? timestamp,
    Expression<int>? durationMinutes,
    Expression<double>? averageSeverity,
    Expression<String>? camera,
    Expression<int>? retentionMonths,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timestamp != null) 'timestamp': timestamp,
      if (durationMinutes != null) 'duration_minutes': durationMinutes,
      if (averageSeverity != null) 'average_severity': averageSeverity,
      if (camera != null) 'camera': camera,
      if (retentionMonths != null) 'retention_months': retentionMonths,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SessionReportTableCompanion copyWith(
      {Value<String>? id,
      Value<DateTime>? timestamp,
      Value<int>? durationMinutes,
      Value<double>? averageSeverity,
      Value<String>? camera,
      Value<int>? retentionMonths,
      Value<int>? rowid}) {
    return SessionReportTableCompanion(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      averageSeverity: averageSeverity ?? this.averageSeverity,
      camera: camera ?? this.camera,
      retentionMonths: retentionMonths ?? this.retentionMonths,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (durationMinutes.present) {
      map['duration_minutes'] = Variable<int>(durationMinutes.value);
    }
    if (averageSeverity.present) {
      map['average_severity'] = Variable<double>(averageSeverity.value);
    }
    if (camera.present) {
      map['camera'] = Variable<String>(camera.value);
    }
    if (retentionMonths.present) {
      map['retention_months'] = Variable<int>(retentionMonths.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SessionReportTableCompanion(')
          ..write('id: $id, ')
          ..write('timestamp: $timestamp, ')
          ..write('durationMinutes: $durationMinutes, ')
          ..write('averageSeverity: $averageSeverity, ')
          ..write('camera: $camera, ')
          ..write('retentionMonths: $retentionMonths, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlertTableTable extends AlertTable
    with TableInfo<$AlertTableTable, AlertTableData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlertTableTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _timestampMeta =
      const VerificationMeta('timestamp');
  @override
  late final GeneratedColumn<DateTime> timestamp = GeneratedColumn<DateTime>(
      'timestamp', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _severityMeta =
      const VerificationMeta('severity');
  @override
  late final GeneratedColumn<double> severity = GeneratedColumn<double>(
      'severity', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _reportIdMeta =
      const VerificationMeta('reportId');
  @override
  late final GeneratedColumn<String> reportId = GeneratedColumn<String>(
      'report_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES session_report_table (id)'));
  @override
  List<GeneratedColumn> get $columns =>
      [id, type, timestamp, severity, reportId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alert_table';
  @override
  VerificationContext validateIntegrity(Insertable<AlertTableData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('timestamp')) {
      context.handle(_timestampMeta,
          timestamp.isAcceptableOrUnknown(data['timestamp']!, _timestampMeta));
    } else if (isInserting) {
      context.missing(_timestampMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(_severityMeta,
          severity.isAcceptableOrUnknown(data['severity']!, _severityMeta));
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('report_id')) {
      context.handle(_reportIdMeta,
          reportId.isAcceptableOrUnknown(data['report_id']!, _reportIdMeta));
    } else if (isInserting) {
      context.missing(_reportIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlertTableData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlertTableData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      timestamp: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}timestamp'])!,
      severity: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}severity'])!,
      reportId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}report_id'])!,
    );
  }

  @override
  $AlertTableTable createAlias(String alias) {
    return $AlertTableTable(attachedDatabase, alias);
  }
}

class AlertTableData extends DataClass implements Insertable<AlertTableData> {
  final String id;
  final String type;
  final DateTime timestamp;
  final double severity;
  final String reportId;
  const AlertTableData(
      {required this.id,
      required this.type,
      required this.timestamp,
      required this.severity,
      required this.reportId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['type'] = Variable<String>(type);
    map['timestamp'] = Variable<DateTime>(timestamp);
    map['severity'] = Variable<double>(severity);
    map['report_id'] = Variable<String>(reportId);
    return map;
  }

  AlertTableCompanion toCompanion(bool nullToAbsent) {
    return AlertTableCompanion(
      id: Value(id),
      type: Value(type),
      timestamp: Value(timestamp),
      severity: Value(severity),
      reportId: Value(reportId),
    );
  }

  factory AlertTableData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlertTableData(
      id: serializer.fromJson<String>(json['id']),
      type: serializer.fromJson<String>(json['type']),
      timestamp: serializer.fromJson<DateTime>(json['timestamp']),
      severity: serializer.fromJson<double>(json['severity']),
      reportId: serializer.fromJson<String>(json['reportId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'type': serializer.toJson<String>(type),
      'timestamp': serializer.toJson<DateTime>(timestamp),
      'severity': serializer.toJson<double>(severity),
      'reportId': serializer.toJson<String>(reportId),
    };
  }

  AlertTableData copyWith(
          {String? id,
          String? type,
          DateTime? timestamp,
          double? severity,
          String? reportId}) =>
      AlertTableData(
        id: id ?? this.id,
        type: type ?? this.type,
        timestamp: timestamp ?? this.timestamp,
        severity: severity ?? this.severity,
        reportId: reportId ?? this.reportId,
      );
  AlertTableData copyWithCompanion(AlertTableCompanion data) {
    return AlertTableData(
      id: data.id.present ? data.id.value : this.id,
      type: data.type.present ? data.type.value : this.type,
      timestamp: data.timestamp.present ? data.timestamp.value : this.timestamp,
      severity: data.severity.present ? data.severity.value : this.severity,
      reportId: data.reportId.present ? data.reportId.value : this.reportId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlertTableData(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('timestamp: $timestamp, ')
          ..write('severity: $severity, ')
          ..write('reportId: $reportId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, type, timestamp, severity, reportId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlertTableData &&
          other.id == this.id &&
          other.type == this.type &&
          other.timestamp == this.timestamp &&
          other.severity == this.severity &&
          other.reportId == this.reportId);
}

class AlertTableCompanion extends UpdateCompanion<AlertTableData> {
  final Value<String> id;
  final Value<String> type;
  final Value<DateTime> timestamp;
  final Value<double> severity;
  final Value<String> reportId;
  final Value<int> rowid;
  const AlertTableCompanion({
    this.id = const Value.absent(),
    this.type = const Value.absent(),
    this.timestamp = const Value.absent(),
    this.severity = const Value.absent(),
    this.reportId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlertTableCompanion.insert({
    required String id,
    required String type,
    required DateTime timestamp,
    required double severity,
    required String reportId,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        type = Value(type),
        timestamp = Value(timestamp),
        severity = Value(severity),
        reportId = Value(reportId);
  static Insertable<AlertTableData> custom({
    Expression<String>? id,
    Expression<String>? type,
    Expression<DateTime>? timestamp,
    Expression<double>? severity,
    Expression<String>? reportId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (type != null) 'type': type,
      if (timestamp != null) 'timestamp': timestamp,
      if (severity != null) 'severity': severity,
      if (reportId != null) 'report_id': reportId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlertTableCompanion copyWith(
      {Value<String>? id,
      Value<String>? type,
      Value<DateTime>? timestamp,
      Value<double>? severity,
      Value<String>? reportId,
      Value<int>? rowid}) {
    return AlertTableCompanion(
      id: id ?? this.id,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      severity: severity ?? this.severity,
      reportId: reportId ?? this.reportId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (timestamp.present) {
      map['timestamp'] = Variable<DateTime>(timestamp.value);
    }
    if (severity.present) {
      map['severity'] = Variable<double>(severity.value);
    }
    if (reportId.present) {
      map['report_id'] = Variable<String>(reportId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlertTableCompanion(')
          ..write('id: $id, ')
          ..write('type: $type, ')
          ..write('timestamp: $timestamp, ')
          ..write('severity: $severity, ')
          ..write('reportId: $reportId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SessionReportTableTable sessionReportTable =
      $SessionReportTableTable(this);
  late final $AlertTableTable alertTable = $AlertTableTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [sessionReportTable, alertTable];
}

typedef $$SessionReportTableTableCreateCompanionBuilder
    = SessionReportTableCompanion Function({
  required String id,
  required DateTime timestamp,
  required int durationMinutes,
  required double averageSeverity,
  required String camera,
  required int retentionMonths,
  Value<int> rowid,
});
typedef $$SessionReportTableTableUpdateCompanionBuilder
    = SessionReportTableCompanion Function({
  Value<String> id,
  Value<DateTime> timestamp,
  Value<int> durationMinutes,
  Value<double> averageSeverity,
  Value<String> camera,
  Value<int> retentionMonths,
  Value<int> rowid,
});

final class $$SessionReportTableTableReferences extends BaseReferences<
    _$AppDatabase, $SessionReportTableTable, SessionReportTableData> {
  $$SessionReportTableTableReferences(
      super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$AlertTableTable, List<AlertTableData>>
      _alertTableRefsTable(_$AppDatabase db) =>
          MultiTypedResultKey.fromTable(db.alertTable,
              aliasName: $_aliasNameGenerator(
                  db.sessionReportTable.id, db.alertTable.reportId));

  $$AlertTableTableProcessedTableManager get alertTableRefs {
    final manager = $$AlertTableTableTableManager($_db, $_db.alertTable)
        .filter((f) => f.reportId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_alertTableRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$SessionReportTableTableFilterComposer
    extends Composer<_$AppDatabase, $SessionReportTableTable> {
  $$SessionReportTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get averageSeverity => $composableBuilder(
      column: $table.averageSeverity,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get camera => $composableBuilder(
      column: $table.camera, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get retentionMonths => $composableBuilder(
      column: $table.retentionMonths,
      builder: (column) => ColumnFilters(column));

  Expression<bool> alertTableRefs(
      Expression<bool> Function($$AlertTableTableFilterComposer f) f) {
    final $$AlertTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.alertTable,
        getReferencedColumn: (t) => t.reportId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlertTableTableFilterComposer(
              $db: $db,
              $table: $db.alertTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SessionReportTableTableOrderingComposer
    extends Composer<_$AppDatabase, $SessionReportTableTable> {
  $$SessionReportTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get averageSeverity => $composableBuilder(
      column: $table.averageSeverity,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get camera => $composableBuilder(
      column: $table.camera, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get retentionMonths => $composableBuilder(
      column: $table.retentionMonths,
      builder: (column) => ColumnOrderings(column));
}

class $$SessionReportTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $SessionReportTableTable> {
  $$SessionReportTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<int> get durationMinutes => $composableBuilder(
      column: $table.durationMinutes, builder: (column) => column);

  GeneratedColumn<double> get averageSeverity => $composableBuilder(
      column: $table.averageSeverity, builder: (column) => column);

  GeneratedColumn<String> get camera =>
      $composableBuilder(column: $table.camera, builder: (column) => column);

  GeneratedColumn<int> get retentionMonths => $composableBuilder(
      column: $table.retentionMonths, builder: (column) => column);

  Expression<T> alertTableRefs<T extends Object>(
      Expression<T> Function($$AlertTableTableAnnotationComposer a) f) {
    final $$AlertTableTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.alertTable,
        getReferencedColumn: (t) => t.reportId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$AlertTableTableAnnotationComposer(
              $db: $db,
              $table: $db.alertTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$SessionReportTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $SessionReportTableTable,
    SessionReportTableData,
    $$SessionReportTableTableFilterComposer,
    $$SessionReportTableTableOrderingComposer,
    $$SessionReportTableTableAnnotationComposer,
    $$SessionReportTableTableCreateCompanionBuilder,
    $$SessionReportTableTableUpdateCompanionBuilder,
    (SessionReportTableData, $$SessionReportTableTableReferences),
    SessionReportTableData,
    PrefetchHooks Function({bool alertTableRefs})> {
  $$SessionReportTableTableTableManager(
      _$AppDatabase db, $SessionReportTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SessionReportTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SessionReportTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SessionReportTableTableAnnotationComposer(
                  $db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<int> durationMinutes = const Value.absent(),
            Value<double> averageSeverity = const Value.absent(),
            Value<String> camera = const Value.absent(),
            Value<int> retentionMonths = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              SessionReportTableCompanion(
            id: id,
            timestamp: timestamp,
            durationMinutes: durationMinutes,
            averageSeverity: averageSeverity,
            camera: camera,
            retentionMonths: retentionMonths,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required DateTime timestamp,
            required int durationMinutes,
            required double averageSeverity,
            required String camera,
            required int retentionMonths,
            Value<int> rowid = const Value.absent(),
          }) =>
              SessionReportTableCompanion.insert(
            id: id,
            timestamp: timestamp,
            durationMinutes: durationMinutes,
            averageSeverity: averageSeverity,
            camera: camera,
            retentionMonths: retentionMonths,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$SessionReportTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({alertTableRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (alertTableRefs) db.alertTable],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (alertTableRefs)
                    await $_getPrefetchedData<SessionReportTableData,
                            $SessionReportTableTable, AlertTableData>(
                        currentTable: table,
                        referencedTable: $$SessionReportTableTableReferences
                            ._alertTableRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$SessionReportTableTableReferences(db, table, p0)
                                .alertTableRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.reportId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$SessionReportTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $SessionReportTableTable,
    SessionReportTableData,
    $$SessionReportTableTableFilterComposer,
    $$SessionReportTableTableOrderingComposer,
    $$SessionReportTableTableAnnotationComposer,
    $$SessionReportTableTableCreateCompanionBuilder,
    $$SessionReportTableTableUpdateCompanionBuilder,
    (SessionReportTableData, $$SessionReportTableTableReferences),
    SessionReportTableData,
    PrefetchHooks Function({bool alertTableRefs})>;
typedef $$AlertTableTableCreateCompanionBuilder = AlertTableCompanion Function({
  required String id,
  required String type,
  required DateTime timestamp,
  required double severity,
  required String reportId,
  Value<int> rowid,
});
typedef $$AlertTableTableUpdateCompanionBuilder = AlertTableCompanion Function({
  Value<String> id,
  Value<String> type,
  Value<DateTime> timestamp,
  Value<double> severity,
  Value<String> reportId,
  Value<int> rowid,
});

final class $$AlertTableTableReferences
    extends BaseReferences<_$AppDatabase, $AlertTableTable, AlertTableData> {
  $$AlertTableTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $SessionReportTableTable _reportIdTable(_$AppDatabase db) =>
      db.sessionReportTable.createAlias($_aliasNameGenerator(
          db.alertTable.reportId, db.sessionReportTable.id));

  $$SessionReportTableTableProcessedTableManager get reportId {
    final $_column = $_itemColumn<String>('report_id')!;

    final manager =
        $$SessionReportTableTableTableManager($_db, $_db.sessionReportTable)
            .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_reportIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$AlertTableTableFilterComposer
    extends Composer<_$AppDatabase, $AlertTableTable> {
  $$AlertTableTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnFilters(column));

  $$SessionReportTableTableFilterComposer get reportId {
    final $$SessionReportTableTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reportId,
        referencedTable: $db.sessionReportTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionReportTableTableFilterComposer(
              $db: $db,
              $table: $db.sessionReportTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AlertTableTableOrderingComposer
    extends Composer<_$AppDatabase, $AlertTableTable> {
  $$AlertTableTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get timestamp => $composableBuilder(
      column: $table.timestamp, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get severity => $composableBuilder(
      column: $table.severity, builder: (column) => ColumnOrderings(column));

  $$SessionReportTableTableOrderingComposer get reportId {
    final $$SessionReportTableTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.reportId,
        referencedTable: $db.sessionReportTable,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$SessionReportTableTableOrderingComposer(
              $db: $db,
              $table: $db.sessionReportTable,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$AlertTableTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlertTableTable> {
  $$AlertTableTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<DateTime> get timestamp =>
      $composableBuilder(column: $table.timestamp, builder: (column) => column);

  GeneratedColumn<double> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  $$SessionReportTableTableAnnotationComposer get reportId {
    final $$SessionReportTableTableAnnotationComposer composer =
        $composerBuilder(
            composer: this,
            getCurrentColumn: (t) => t.reportId,
            referencedTable: $db.sessionReportTable,
            getReferencedColumn: (t) => t.id,
            builder: (joinBuilder,
                    {$addJoinBuilderToRootComposer,
                    $removeJoinBuilderFromRootComposer}) =>
                $$SessionReportTableTableAnnotationComposer(
                  $db: $db,
                  $table: $db.sessionReportTable,
                  $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                  joinBuilder: joinBuilder,
                  $removeJoinBuilderFromRootComposer:
                      $removeJoinBuilderFromRootComposer,
                ));
    return composer;
  }
}

class $$AlertTableTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AlertTableTable,
    AlertTableData,
    $$AlertTableTableFilterComposer,
    $$AlertTableTableOrderingComposer,
    $$AlertTableTableAnnotationComposer,
    $$AlertTableTableCreateCompanionBuilder,
    $$AlertTableTableUpdateCompanionBuilder,
    (AlertTableData, $$AlertTableTableReferences),
    AlertTableData,
    PrefetchHooks Function({bool reportId})> {
  $$AlertTableTableTableManager(_$AppDatabase db, $AlertTableTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlertTableTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlertTableTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlertTableTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<DateTime> timestamp = const Value.absent(),
            Value<double> severity = const Value.absent(),
            Value<String> reportId = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              AlertTableCompanion(
            id: id,
            type: type,
            timestamp: timestamp,
            severity: severity,
            reportId: reportId,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String type,
            required DateTime timestamp,
            required double severity,
            required String reportId,
            Value<int> rowid = const Value.absent(),
          }) =>
              AlertTableCompanion.insert(
            id: id,
            type: type,
            timestamp: timestamp,
            severity: severity,
            reportId: reportId,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$AlertTableTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({reportId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (reportId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.reportId,
                    referencedTable:
                        $$AlertTableTableReferences._reportIdTable(db),
                    referencedColumn:
                        $$AlertTableTableReferences._reportIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$AlertTableTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AlertTableTable,
    AlertTableData,
    $$AlertTableTableFilterComposer,
    $$AlertTableTableOrderingComposer,
    $$AlertTableTableAnnotationComposer,
    $$AlertTableTableCreateCompanionBuilder,
    $$AlertTableTableUpdateCompanionBuilder,
    (AlertTableData, $$AlertTableTableReferences),
    AlertTableData,
    PrefetchHooks Function({bool reportId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SessionReportTableTableTableManager get sessionReportTable =>
      $$SessionReportTableTableTableManager(_db, _db.sessionReportTable);
  $$AlertTableTableTableManager get alertTable =>
      $$AlertTableTableTableManager(_db, _db.alertTable);
}
