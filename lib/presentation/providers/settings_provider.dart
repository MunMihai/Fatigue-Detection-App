import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:flutter/material.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  late SharedPreferences _prefs;

  bool _isCounterEnabled = false;
  bool _isReportsSectionEnabled = false;
  int _retentionMonths = 0;
  int _savedHours = 0;
  int _savedMinutes = 0;
  int _sessionSensitivity = 5;
  String _languageCode = 'en';
  FaceDetectorMode _faceDetectorMode = FaceDetectorMode.accurate;
  ThemeMode _themeMode = ThemeMode.system;
  bool _isNightLightEnabled = false;

  bool get isCounterEnabled => _isCounterEnabled;
  bool get isReportsSectionEnabled => _isReportsSectionEnabled;
  int get retentionMonths => _retentionMonths;
  int get savedHours => _savedHours;
  int get savedMinutes => _savedMinutes;
  int get sessionSensitivity => _sessionSensitivity;
  String get languageCode => _languageCode;
  FaceDetectorMode get faceDetectorMode => _faceDetectorMode;
  ThemeMode get themeMode => _themeMode;
  bool get isNightLightEnabled => _isNightLightEnabled;

  Future<void> loadSettings() async {
    _prefs = await SharedPreferences.getInstance();

    _isCounterEnabled = _prefs.getBool('enable_counter') ?? false;
    _isReportsSectionEnabled = _prefs.getBool('show_reports_section') ?? false;
    _retentionMonths = _prefs.getInt('reports_retention_months') ?? 12;
    _savedHours = _prefs.getInt('alarm_time_hours') ?? 2;
    _savedMinutes = _prefs.getInt('alarm_time_minutes') ?? 0;
    _sessionSensitivity = _prefs.getInt('_session_sensibility') ?? 5;
    _languageCode = _prefs.getString('language_code') ?? 'en';
    _isNightLightEnabled =
        _prefs.getBool('enable_night_light') ?? false; // ➡️ aici
    final modeString = _prefs.getString('face_detector_mode') ?? 'fast';
    _faceDetectorMode = FaceDetectorMode.values.firstWhere(
      (e) => e.name == modeString,
      orElse: () => FaceDetectorMode.fast,
    );
    final themeString = _prefs.getString('theme_mode') ?? 'system';
    _themeMode = ThemeMode.values.firstWhere(
      (e) => e.name == themeString,
      orElse: () => ThemeMode.system,
    );

    appLogger.i('🔧 Settings loaded');
    appLogger.i('   ▸ Counter enabled: $_isCounterEnabled');
    appLogger.i('   ▸ Reports section enabled: $_isReportsSectionEnabled');
    appLogger.i('   ▸ Retention months: $_retentionMonths');
    appLogger.i('   ▸ Alarm time: $_savedHours h $_savedMinutes min');
    appLogger.i('   ▸ Sensibility: $_sessionSensitivity');
    appLogger.i('   ▸ Language code: $_languageCode');
    appLogger.i('   ▸ Night light: $_isNightLightEnabled');
    appLogger.i('   ▸ Performance mode: $_faceDetectorMode');
    appLogger.i('   ▸ Theme: $_themeMode');

    notifyListeners();
  }

  Future<void> toggleNightLight(bool value) async {
    _isNightLightEnabled = value;
    await _prefs.setBool('enable_night_light', value);

    appLogger.i('🌙 Night light toggled → $_isNightLightEnabled');

    notifyListeners();
  }

  Future<void> updateThemeMode(ThemeMode mode) async {
    _themeMode = mode;
    await _prefs.setString('theme_mode', mode.name);

    appLogger.i('🎨 Theme mode updated → $_themeMode');

    notifyListeners();
  }

  Future<void> updateFaceDetectorMode(FaceDetectorMode mode) async {
    _faceDetectorMode = mode;
    await _prefs.setString('face_detector_mode', mode.name);

    appLogger.i('🧠 Face detector mode updated → $_faceDetectorMode');

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

  Future<void> updateLanguageCode(String newCode) async {
    _languageCode = newCode;
    await _prefs.setString('language_code', newCode);

    appLogger.i('🌐 Language updated → $_languageCode');

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

  Future<void> updateSessionSensibility(int value) async {
    _sessionSensitivity = value;

    await _prefs.setInt('_session_sensibility', _sessionSensitivity);

    appLogger.i('🎛️ Session sensitivity updated → $_sessionSensitivity');

    notifyListeners();
  }
}
