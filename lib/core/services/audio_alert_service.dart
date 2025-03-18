import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';

class AudioAlertService {
  bool _isAlertActive = false;
  DateTime? _lastAlertTime;
  final Duration _alertCooldown = Duration(seconds: 5);

  // Instanța corectă conform noii versiuni
  final FlutterRingtonePlayer _ringtonePlayer = FlutterRingtonePlayer();

    void triggerAlert() async {
    final now = DateTime.now();

    if (_lastAlertTime != null && now.difference(_lastAlertTime!) < _alertCooldown) {
      appLogger.d('⌛ Cooldown activ. Nu declanșăm alerta.');
      return;
    }

    if (_isAlertActive) {
      appLogger.d('🚨 Alerta deja activă!');
      return;
    }

    _isAlertActive = true;
    _lastAlertTime = now;

    appLogger.w('🚨 ALERTĂ SONORĂ: Ambii ochi închiși detectați! 🚨');

    try {
      // Încerci să redai sunetul custom din assets
      await _ringtonePlayer.play(
        fromAsset: "assets/sounds/warning_1.mp3",
        looping: true,
        volume: 1.0,
        asAlarm: true,
      );

      appLogger.i('🔊 Redare sunet custom din assets cu succes!');
    } catch (e) {
      // Dacă fail, fallback la alerta default
      appLogger.e('❌ Eroare redare asset. Fallback pe sunet sistem: $e');

      try {
        await _ringtonePlayer.play(
          android: AndroidSounds.alarm,
          ios: IosSounds.alarm,
          looping: true,
          volume: 1.0,
          asAlarm: true,
        );

        appLogger.w('🚨 ALERTĂ fallback pe sunetul sistemului!');
      } catch (fallbackError) {
        appLogger.e('❌ Eroare fallback alertă: $fallbackError');
      }
    }
  }

  void stopAlert() {
    if (!_isAlertActive) {
      appLogger.d('✅ Nicio alertă activă de oprit.');
      return;
    }

    _isAlertActive = false;
    appLogger.i('🛑 Alerta sonoră oprită.');

    _ringtonePlayer.stop();
  }

  void dispose() {
    stopAlert();
  }
}
