import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';

class AudioAlertService {
  bool _isAlertActive = false;
  DateTime? _lastAlertTime;
  final Duration _alertCooldown = Duration(seconds: 5);

  final FlutterRingtonePlayer _ringtonePlayer = FlutterRingtonePlayer();

  void triggerAlert() async {
    final now = DateTime.now();

    if (_lastAlertTime != null && now.difference(_lastAlertTime!) < _alertCooldown) {
      appLogger.d('⌛ Cooldown active. Alert not triggered.');
      return;
    }

    if (_isAlertActive) {
      appLogger.d('🚨 Alert already active!');
      return;
    }

    _isAlertActive = true;
    _lastAlertTime = now;

    appLogger.w('🚨 AUDIO ALERT: Both eyes closed detected! 🚨');

    try {
      await _ringtonePlayer.play(
        fromAsset: "assets/sounds/warning_1.mp3",
        looping: true,
        volume: 1.0,
        asAlarm: true,
      );

      appLogger.i('🔊 Custom asset sound playing successfully!');
    } catch (e) {
      appLogger.e('❌ Error playing custom asset. Falling back to system alarm sound: $e');

      try {
        await _ringtonePlayer.play(
          android: AndroidSounds.alarm,
          ios: IosSounds.alarm,
          looping: true,
          volume: 1.0,
          asAlarm: true,
        );

        appLogger.w('🚨 Fallback alert playing using system sound!');
      } catch (fallbackError) {
        appLogger.e('❌ Error triggering fallback alert: $fallbackError');
      }
    }
  }

  void stopAlert() {
    if (!_isAlertActive) {
      appLogger.d('✅ No active alert to stop.');
      return;
    }

    _isAlertActive = false;
    appLogger.i('🛑 Audio alert stopped.');

    _ringtonePlayer.stop();
  }

  void dispose() {
    stopAlert();
  }
}
