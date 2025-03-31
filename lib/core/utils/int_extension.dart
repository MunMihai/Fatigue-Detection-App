import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

extension MinuteFormat on int {
  String toHoursAndMinutes(BuildContext context) {
    final tr = AppLocalizations.of(context)!;
    int hours = this ~/ 60;
    int minutes = this % 60;

    return '$hours${tr.hours} ${minutes.toString().padLeft(2, '0')}${tr.minutes}';
  }
}

extension MinuteFormatWithSeconds on int {
  String toHoursMinutesAndSeconds(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    int hours = this ~/ 3600;
    int minutes = (this % 3600) ~/ 60;
    int seconds = this % 60;

    return '$hours${tr.hours} ${minutes.toString().padLeft(2, '0')}${tr.minutes} ${seconds.toString().padLeft(2, '0')}${tr.seconds}';
  }
}
