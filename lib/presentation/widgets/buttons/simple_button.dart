import 'package:flutter/material.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/theme/color_scheme_extensions.dart';

class PrimaryButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final Color? color; // <-- Culoare din exterior, opțională

  const PrimaryButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.width = 340,
    this.height = 56,
    this.color, // <-- adăugăm în constructor
  });

  @override
  Widget build(BuildContext context) {
    final Color backgroundColor = color ?? Theme.of(context).colorScheme.primaryButton;
    // Dacă color != null => folosim color
    // Dacă color == null => folosim tema implicită

    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        minimumSize: Size(width, height),
      ),
      child: Text(
        title,
        style: AppTextStyles.h3(context).copyWith(
          color: Theme.of(context).colorScheme.onPrimaryButton,
        ),
      ),
    );
  }
}
