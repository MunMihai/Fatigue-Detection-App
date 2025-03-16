import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  late SharedPreferences _prefs;

  bool _isCounterEnabled = false;
  bool _isReportsSectionEnabled = false;
  int _retentionMonths = 0;
  int _savedHours = 0;
  int _savedMinutes = 0;

  // Getters publici
  bool get isCounterEnabled => _isCounterEnabled;
  bool get isReportsSectionEnabled => _isReportsSectionEnabled;
  int get retentionMonths => _retentionMonths;
  int get savedHours => _savedHours;
  int get savedMinutes => _savedMinutes;

  /// Inițializare settings + încărcare valori
  Future<void> loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    _isCounterEnabled = _prefs.getBool('enable_counter') ?? false;
    _isReportsSectionEnabled = _prefs.getBool('show_reports_section') ?? false;
    _retentionMonths = _prefs.getInt('reports_retention_months') ?? 12;
    _savedHours = _prefs.getInt('alarm_time_hours') ?? 2;
    _savedMinutes = _prefs.getInt('alarm_time_minutes') ?? 0;

    appLogger.i('🔧 Settings loaded');
    appLogger.i('   ▸ Counter enabled: $_isCounterEnabled');
    appLogger.i('   ▸ Reports section enabled: $_isReportsSectionEnabled');
    appLogger.i('   ▸ Retention months: $_retentionMonths');
    appLogger.i('   ▸ Alarm time: $_savedHours h $_savedMinutes min');

    notifyListeners();
  }

  Future<void> toggleCounter(bool value) async {
    _isCounterEnabled = value;
    await _prefs.setBool('enable_counter', value);

    appLogger.i('🕹️ Counter toggled → $_isCounterEnabled');

    notifyListeners();
  }

  Future<void> toggleReportsSection(bool value) async {
    _isReportsSectionEnabled = value;
    await _prefs.setBool('show_reports_section', value);

    appLogger.i('📄 Reports section toggled → $_isReportsSectionEnabled');

    notifyListeners();
  }

  Future<void> updateTime(Duration duration) async {
    _savedHours = duration.inHours;
    _savedMinutes = duration.inMinutes % 60;

    await _prefs.setInt('alarm_time_hours', _savedHours);
    await _prefs.setInt('alarm_time_minutes', _savedMinutes);

    appLogger.i('⏰ Alarm time updated → $_savedHours h $_savedMinutes min');

    notifyListeners();
  }

  Future<void> incrementRetentionMonths() async {
    if (_retentionMonths < 24) {
      _retentionMonths++;
      await _prefs.setInt('reports_retention_months', _retentionMonths);

      appLogger.i('📅 Retention months incremented → $_retentionMonths');
    } else {
      appLogger.w('⚠️ Maximum retention months reached (24)');
    }

    notifyListeners();
  }

  Future<void> decrementRetentionMonths() async {
    if (_retentionMonths > 1) {
      _retentionMonths--;
      await _prefs.setInt('reports_retention_months', _retentionMonths);

      appLogger.i('📅 Retention months decremented → $_retentionMonths');
    } else {
      appLogger.w('⚠️ Minimum retention months reached (1)');
    }

    notifyListeners();
  }

  Future<void> incrementRetentionByYear() async {
    if (_retentionMonths <= 12) {
      _retentionMonths += 12;
    } else {
      _retentionMonths = 24;
    }

    await _prefs.setInt('reports_retention_months', _retentionMonths);

    appLogger.i('📅 Retention increased by year → $_retentionMonths');

    notifyListeners();
  }

  Future<void> decrementRetentionByYear() async {
    if (_retentionMonths > 12) {
      _retentionMonths -= 12;
    } else {
      _retentionMonths = 1;
    }

    await _prefs.setInt('reports_retention_months', _retentionMonths);

    appLogger.i('📅 Retention decreased by year → $_retentionMonths');

    notifyListeners();
  }
}
