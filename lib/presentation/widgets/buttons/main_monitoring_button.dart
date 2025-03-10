import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/utils/color_scheme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainMonitoringButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const MainMonitoringButton({
    super.key,
    required this.title,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Theme.of(context).colorScheme.onPrimary,
          minimumSize: const Size(340, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(100),
            side: BorderSide(
              color:
                  Theme.of(context).colorScheme.stroke, // culoarea borderului
              width: 5, // grosimea borderului
            ),
          ),
          elevation: 5,
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        ),
        child: Text(title,
            style: AppTextStyles.michroma, textAlign: TextAlign.center));
  }
}
