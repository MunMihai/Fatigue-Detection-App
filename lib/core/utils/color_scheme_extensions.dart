import 'package:flutter/material.dart';

extension MyColorScheme on ColorScheme{
  Color get primaryButton => const Color(0xFF1A80E5);
  Color get onPrimaryButton => Colors.white;

  Color get secondaryButton => const Color(0xFF2C2F31);
  Color get onSecondaryButton => Colors.white;

  Color get stroke => const Color(0xFF0C1217);
}