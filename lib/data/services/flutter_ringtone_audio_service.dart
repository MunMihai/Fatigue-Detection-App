import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:driver_monitoring/core/utils/app_logger.dart';
import 'package:driver_monitoring/domain/services/audio_service.dart';

class FlutterRingtoneAudioService implements AudioService {
  bool _isAlertActive = false;
  DateTime? _lastAlertTime;

  final Duration _alertCooldown;
  final String alertSoundAsset;
  final double volume;

  FlutterRingtoneAudioService({
    Duration cooldown = const Duration(seconds: 2),
    this.alertSoundAsset = 'assets/sounds/warning_1.mp3',
    this.volume = 1.0,
  }) : _alertCooldown = cooldown;

  @override
  Future<void> playAudio() async {
    final now = DateTime.now();

    if (_isOnCooldown(now)) {
      appLogger.d('⌛ Cooldown active. Alert not triggered.');
      return;
    }

    if (_isAlertActive) {
      appLogger.d('🚨 Alert already active!');
      return;
    }

    _isAlertActive = true;
    _lastAlertTime = now;

    appLogger.w('🚨 AUDIO ALERT triggered!');

    try {
      await _playCustomAlert();
    } catch (error) {
      appLogger.e('❌ Error playing custom asset: $error');
      await _playFallbackAlert();
    }
  }

  @override
  void stopAudio() {
    if (!_isAlertActive) {
      appLogger.d('✅ No active alert to stop.');
      return;
    }

    _isAlertActive = false;
    FlutterRingtonePlayer().stop();
    appLogger.i('🛑 Audio alert stopped.');
  }

  bool _isOnCooldown(DateTime now) {
    return _lastAlertTime != null &&
        now.difference(_lastAlertTime!) < _alertCooldown;
  }

  Future<void> _playCustomAlert() async {
    appLogger.i('🔊 Playing custom asset: $alertSoundAsset');
    await FlutterRingtonePlayer().play(
      fromAsset: alertSoundAsset,
      looping: true,
      volume: volume,
      asAlarm: true,
    );
    appLogger.i('✅ Custom asset playing successfully!');
  }

  Future<void> _playFallbackAlert() async {
    try {
      await FlutterRingtonePlayer().play(
        android: AndroidSounds.alarm,
        ios: IosSounds.alarm,
        looping: true,
        volume: volume,
        asAlarm: true,
      );
      appLogger.w('🚨 Fallback system sound playing!');
    } catch (fallbackError) {
      appLogger.e('❌ Error triggering fallback alert: $fallbackError');
    }
  }
}
