import 'package:driver_monitoring/data/datasources/local/app_database.dart';

class DatabaseProvider {
  static final DatabaseProvider _instance = DatabaseProvider._internal();

  late final AppDatabase _db;

  DatabaseProvider._internal() {
    _db = AppDatabase(); 
  }

  factory DatabaseProvider() {
    return _instance;
  }

  AppDatabase get database => _db;
}
