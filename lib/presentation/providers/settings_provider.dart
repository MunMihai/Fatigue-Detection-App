import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  late SharedPreferencesAsync _prefs;

  bool _isCounterEnabled = false;
  bool _isReportsSectionEnabled = false;
  int _retentionMonths = 12;
  int _savedHours = 2;
  int _savedMinutes = 0;

  bool get isCounterEnabled => _isCounterEnabled;
  bool get isReportsSectionEnabled => _isReportsSectionEnabled;
  int get retentionMonths => _retentionMonths;
  int get savedHours => _savedHours;
  int get savedMinutes => _savedMinutes;

  /// Inițializare settings + încărcare valori
  Future<void> loadSettings() async {
    _prefs = SharedPreferencesAsync(); // Corect: NU e async

    _isCounterEnabled = await _prefs.getBool('enable_counter') ?? false;
    _isReportsSectionEnabled = await _prefs.getBool('show_reports_section') ?? false;
    _retentionMonths = await _prefs.getInt('reports_retention_months') ?? 12;
    _savedHours = await _prefs.getInt('alarm_time_hours') ?? 2;
    _savedMinutes = await _prefs.getInt('alarm_time_minutes') ?? 0;

    notifyListeners();
  }

  Future<void> toggleCounter(bool value) async {
    _isCounterEnabled = value;
    await _prefs.setBool('enable_counter', value);
    notifyListeners();
  }

  Future<void> toggleReportsSection(bool value) async {
    _isReportsSectionEnabled = value;
    await _prefs.setBool('show_reports_section', value);
    notifyListeners();
  }

  Future<void> updateTime(Duration duration) async {
    _savedHours = duration.inHours;
    _savedMinutes = duration.inMinutes % 60;

    await _prefs.setInt('alarm_time_hours', _savedHours);
    await _prefs.setInt('alarm_time_minutes', _savedMinutes);

    notifyListeners();
  }

  Future<void> incrementRetentionMonths() async {
    if (_retentionMonths < 24) {
      _retentionMonths++;
      await _prefs.setInt('reports_retention_months', _retentionMonths);
      notifyListeners();
    }
  }

  Future<void> decrementRetentionMonths() async {
    if (_retentionMonths > 1) {
      _retentionMonths--;
      await _prefs.setInt('reports_retention_months', _retentionMonths);
      notifyListeners();
    }
  }

  Future<void> incrementRetentionByYear() async {
    if (_retentionMonths <= 12) {
      _retentionMonths += 12;
    } else {
      _retentionMonths = 24;
    }

    await _prefs.setInt('reports_retention_months', _retentionMonths);
    notifyListeners();
  }

  Future<void> decrementRetentionByYear() async {
    if (_retentionMonths > 12) {
      _retentionMonths -= 12;
    } else {
      _retentionMonths = 1;
    }

    await _prefs.setInt('reports_retention_months', _retentionMonths);
    notifyListeners();
  }
}
