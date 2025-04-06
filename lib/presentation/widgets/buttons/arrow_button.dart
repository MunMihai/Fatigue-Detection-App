import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/theme/color_scheme_extensions.dart';
import 'package:flutter/material.dart';

class ArrowButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const ArrowButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.onPrimaryButton,
        minimumSize: const Size(340, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        elevation: 5,
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.h4(context),
          ),
          Icon(Icons.arrow_forward, size: 30,)
        ],
      ),
    );
  }
}