import 'package:shared_preferences/shared_preferences.dart';

class PrefsHelper {
  static const String enableCounterKey = 'enable_counter';
  static const String alarmHoursKey = 'alarm_time_hours';
  static const String alarmMinutesKey = 'alarm_time_minutes';

  /// Încarcă setările salvate
  static Future<Map<String, dynamic>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'enabled': prefs.getBool(enableCounterKey) ?? false,
      'hours': prefs.getInt(alarmHoursKey) ?? 2,
      'minutes': prefs.getInt(alarmMinutesKey) ?? 0,
    };
  }

  /// Salvează starea switch-ului
  static Future<void> setCounterEnabled(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(enableCounterKey, value);
  }

  /// Salvează timpul setat
  static Future<void> setAlarmTime(int hours, int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(alarmHoursKey, hours);
    await prefs.setInt(alarmMinutesKey, minutes);
  }
} 
