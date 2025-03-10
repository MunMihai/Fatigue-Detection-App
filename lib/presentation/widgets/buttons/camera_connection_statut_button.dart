import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/utils/color_scheme_extensions.dart';
import 'package:flutter/material.dart';

class CameraStatusButton extends StatelessWidget {
  final String title;
  final String status;
  final VoidCallback onPressed;

  const CameraStatusButton({
    super.key,
    required this.title,
    required this.status,
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
            style: AppTextStyles.h4,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Theme.of(context).colorScheme.primary
            ),
            child: Text(
              status,
              style: AppTextStyles.medium_12,
            ),
          ),
        ],
      ),
    );
  }
}