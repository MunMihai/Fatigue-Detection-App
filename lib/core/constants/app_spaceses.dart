import 'package:flutter/cupertino.dart';

class AppSpaceses {
  // Dimensiuni standard
  static const double tinySpace = 8.0;
  static const double smallSpace = 16.0;
  static const double mediumSpace = 24.0;
  static const double largeSpace = 30.0;

  static const SizedBox verticalLarge = SizedBox(height: largeSpace);
  static const SizedBox verticalExtraLarge = SizedBox(height: largeSpace * 2);
  static const SizedBox verticalMedium  = SizedBox(height: mediumSpace);
  static const SizedBox verticalSmall  = SizedBox(height: smallSpace);
  static const SizedBox verticalTiny  = SizedBox(height: tinySpace);

  static const SizedBox horizontalLarge = SizedBox(width: largeSpace);
  static const SizedBox horizontalExtraLarge = SizedBox(width: largeSpace * 2);
  static const SizedBox horizontalMedium  = SizedBox(width: mediumSpace);
  static const SizedBox horizontalSmall  = SizedBox(width: smallSpace);
  static const SizedBox horizontalTiny  = SizedBox(width: tinySpace);}