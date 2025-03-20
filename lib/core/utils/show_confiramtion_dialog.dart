import 'dart:async';

import 'package:driver_monitoring/core/constants/app_spaceses.dart';
import 'package:driver_monitoring/core/constants/app_text_styles.dart';
import 'package:driver_monitoring/core/utils/color_scheme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Future<bool> showConfirmationDialog({
  required BuildContext context,
  required String message,
  String title = 'Confirmation',
  String confirmText = '',
  String cancelText = '',
  double minButtonWidth = 100, // Width minimă
  double buttonHeight = 40, // Înălțimea fixă a butonului
  bool showIcon = true,
  IconData icon = Icons.warning_amber_rounded,
}) async {
  bool isDialogClosed = false;
  Timer? timer;

  final router = GoRouter.of(context);

  timer = Timer(const Duration(seconds: 15), () {
    if (!isDialogClosed) {
      if (router.canPop()) {
        router.pop(false);
        isDialogClosed = true;
      }
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
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: LayoutBuilder(
            builder: (context, constraints) {
              bool showVertical =
                  (constraints.maxWidth < (minButtonWidth * 2 + 40));
              List<Widget> buttons = [];
              if (cancelText.isNotEmpty) {
                buttons.add(
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: minButtonWidth,
                    ),
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        fixedSize: Size.fromHeight(buttonHeight),
                      ),
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
                );
              }

              if (confirmText.isNotEmpty) {
                if (buttons.isNotEmpty) {
                  buttons.add(showVertical
                      ? const SizedBox(height: 12)
                      : const SizedBox(width: 12));
                }

                buttons.add(
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: minButtonWidth,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        fixedSize: Size.fromHeight(buttonHeight),
                        backgroundColor: Theme.of(context).colorScheme.error,
                      ),
                      onPressed: () {
                        if (!isDialogClosed) {
                          timer?.cancel();
                          Navigator.of(context).pop(true);
                          isDialogClosed = true;
                        }
                      },
                      child: Text(
                        confirmText,
                        style: AppTextStyles.h4,
                      ),
                    ),
                  ),
                );
              }

              return Column(
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
                  showVertical
                      ? Column(
                          children: buttons,
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: buttons,
                        ),
                ],
              );
            },
          ),
        ),
      );
    },
  ).then((value) => value ?? false);
}
