import 'package:flutter/material.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/utils/color_scheme_extensions.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double width;
  final double height;

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.width = 340,
    this.height = 56,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primaryButton,
            foregroundColor: Theme.of(context).colorScheme.onPrimaryButton,
            minimumSize: const Size(340, 56)),
        child: Text(
          title,
          style: AppTextStyles.h3,
        ));
  }
}
