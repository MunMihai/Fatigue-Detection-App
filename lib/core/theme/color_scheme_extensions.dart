import 'package:flutter/material.dart';

extension MyColorScheme on ColorScheme {
  Color get primaryButton => brightness == Brightness.dark
      ? const Color(0xFF1A80E5)
      : const Color(0xFF42A5F5);

  Color get onPrimaryButton => Colors.white;

  Color get secondaryButton => brightness == Brightness.dark
      ? const Color(0xFF2C2F31)
      : const Color(0xFFE3F2FD);

  Color get onSecondaryButton => brightness == Brightness.dark
      ? Colors.white
      : Colors.black;

  Color get stroke => brightness == Brightness.dark
      ? const Color(0xFF0C1217)
      : const Color(0xFFE0E0E0);

  Color get inactiveIcon => brightness == Brightness.dark
      ? const Color(0xFF90A4AE)
      : const Color.fromARGB(255, 226, 245, 255);

  Color get activeIcon => brightness == Brightness.dark
      ? Colors.white
      : Colors.black;

  Color get searchBar => brightness == Brightness.dark
      ? const Color(0xFF62676B)
      : const Color(0xFFF5F5F5);

  Color get popupDialog => brightness == Brightness.dark
      ? const Color(0xFF1B2B39)
      : Colors.white;
}
