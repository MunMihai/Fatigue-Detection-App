import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:flutter/material.dart';

class TimePicker extends StatelessWidget {
  final int hours;
  final int minutes;
  final ValueChanged<Duration> onChanged;

  const TimePicker({
    super.key,
    required this.hours,
    required this.minutes,
    required this.onChanged,
  });

  void _incrementHours(BuildContext context) {
    final newHours = (hours + 1) % 24;
    onChanged(Duration(hours: newHours, minutes: minutes));
  }

  void _decrementHours(BuildContext context) {
    final newHours = (hours - 1) < 0 ? 23 : hours - 1;
    onChanged(Duration(hours: newHours, minutes: minutes));
  }

  void _incrementMinutes(BuildContext context) {
    const step = 5;
    final newMinutes = (minutes + step) % 60;
    onChanged(Duration(hours: hours, minutes: newMinutes));
  }

  void _decrementMinutes(BuildContext context) {
    const step = 1;
    int newMinutes = minutes - step;
    if (newMinutes < 0) {
      newMinutes = 60 - step;
    }
    onChanged(Duration(hours: hours, minutes: newMinutes));
  }

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tr.setAlarmTime, style: AppTextStyles.h4),
            Text(tr.tapToSet, style: AppTextStyles.subtitle),
          ],
        ),

        Row(
          children: [
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_drop_up),
                  iconSize: 30,
                  onPressed: () => _incrementHours(context),
                ),
                Text(
                  hours.toString().padLeft(2, '0'),
                  style: AppTextStyles.h4,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 30,
                  onPressed: () => _decrementHours(context),
                ),
              ],
            ),
            Text('${tr.hours} :', style: AppTextStyles.h4),
            Column(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_drop_up),
                  iconSize: 30,
                  onPressed: () => _incrementMinutes(context),
                ),
                Text(
                  minutes.toString().padLeft(2, '0'),
                  style: AppTextStyles.h4,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_drop_down),
                  iconSize: 30,
                  onPressed: () => _decrementMinutes(context),
                ),
              ],
            ),
            Text(tr.minutes, style: AppTextStyles.h4),
          ],
        ),
      ],
    );
  }
}
