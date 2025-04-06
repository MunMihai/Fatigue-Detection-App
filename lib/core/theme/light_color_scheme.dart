import 'package:flutter/material.dart';

final ColorScheme lightColorScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF42A5F5),  // Albastru mai intens, dar clar pe fundal deschis
  onPrimary: Colors.white,     // Text alb pe butonul albastru

  secondary: Color(0xFF1A80E5), // Același accent albastru ca în dark
  onSecondary: Colors.white,    // Text alb pe accent

  error: Color(0xFFB00020),     // Roșu standard Material Design
  onError: Colors.white,        // Text alb pe eroare

  surface: Color(0xFFFFFFFF),   // Fundal alb (clasic pentru Light Mode)
  onSurface: Color(0xFF1F2F3C), // Text foarte închis, potrivit cu "primary" dark
);
