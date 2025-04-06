import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static TextStyle h1(BuildContext context) => GoogleFonts.manrope(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: Theme.of(context).colorScheme.onSurface,
  );
  static TextStyle h2(BuildContext context) => GoogleFonts.manrope(
    fontSize: 30,
    fontWeight: FontWeight.w900,
    color: Theme.of(context).colorScheme.onSurface,
  );
  static TextStyle h3(BuildContext context) => GoogleFonts.manrope(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: Theme.of(context).colorScheme.onSurface,
  );
  static TextStyle h4(BuildContext context) => GoogleFonts.manrope(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface,
  );
  static TextStyle regular_24(BuildContext context) => GoogleFonts.manrope(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: Theme.of(context).colorScheme.onSurface,
  );
  static TextStyle medium_12(BuildContext context) => GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.onSurface,
  );

  static TextStyle michroma(BuildContext context) => GoogleFonts.michroma(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: Theme.of(context).colorScheme.onPrimary,
  );

  static final TextStyle subtitle = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Color(0xFF748089),
  );

  static final TextStyle helper = GoogleFonts.manrope(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Color(0xFF748089),
    fontStyle: FontStyle.italic
  );

  static TextStyle timer(BuildContext context) => GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).colorScheme.onSurface,
  );
  static TextStyle filterText(BuildContext context) =>GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: Theme.of(context).colorScheme.onSurface,
  );
}
