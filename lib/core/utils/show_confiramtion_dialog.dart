import 'dart:async';
import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/utils/color_scheme_extensions.dart';
import 'package:flutter/material.dart';

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String message,
  String title = 'Confirmation', // Titlul cu valoare implicită
  String confirmText = 'Confirm', // Textul butonului de confirmare
  String cancelText = 'Cancel',  // Textul butonului de anulare
  bool showIcon = true,          // Parametru pentru a controla dacă se afișează iconul
  IconData icon = Icons.warning_amber_rounded, // Iconul (implicit este unul de avertizare)
}) async {
  bool isDialogClosed = false;  // Variabila fără underscore pentru a respecta convențiile Dart
  Timer? timer;

  // Setăm un timer pentru a închide dialogul automat după 15 secunde
  timer = Timer(Duration(seconds: 15), () {
    if (!isDialogClosed) {
      Navigator.of(context).pop(false);
    }
  });

  return await showDialog<bool>(
    context: context,
    barrierDismissible: true,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.popupDialog, 
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (showIcon)
                  Icon(
                    icon,
                    color: Theme.of(context).colorScheme.error,
                    size: 48,
                  ),
                AppSpaceses.verticalTiny,
                Text(
                  title,
                  style: AppTextStyles.h3,
                ),
                AppSpaceses.verticalTiny,
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.subtitle,
                ),
                AppSpaceses.verticalMedium,
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          if (!isDialogClosed) {
                            timer?.cancel();
                            Navigator.of(context).pop(false);
                            isDialogClosed = true;
                          }
                        },
                        child: Text(
                          cancelText,
                          style: AppTextStyles.h4,
                        ),
                      ),
                    ),
                    AppSpaceses.horizontalLarge,
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (!isDialogClosed) {
                            timer?.cancel();
                            Navigator.of(context).pop(true);
                            isDialogClosed = true;
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                        child: Text(
                          confirmText,
                          style: AppTextStyles.h4,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  ).then((value) => value ?? false); // dacă apasă back sau dismiss
}
