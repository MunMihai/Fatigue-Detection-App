import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';

class SensibilitySlider extends StatelessWidget {
  final int sensitivity;
  final ValueChanged<int> onChanged;

  const SensibilitySlider({
    super.key,
    required this.sensitivity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(tr.detectionSensitivity, style: AppTextStyles.h4),
        Slider(
          value: sensitivity.toDouble(),
          min: 1,
          max: 10,
          divisions: 9,
          label: '$sensitivity',
          onChanged: (double newValue) {
            onChanged(newValue.round());
          },
        ),
        Text(
          '${tr.currentSensitivity}: $sensitivity',
          style: AppTextStyles.helper,
        ),
      ],
    );
  }
}
