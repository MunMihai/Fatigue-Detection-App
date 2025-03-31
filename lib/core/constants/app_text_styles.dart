import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  static final TextStyle h1 = GoogleFonts.manrope(
    fontSize: 32,
    fontWeight: FontWeight.w900,
    color: Colors.white,
  );
  static final TextStyle h2 = GoogleFonts.manrope(
    fontSize: 30,
    fontWeight: FontWeight.w900,
    color: Colors.white,
  );
  static final TextStyle h3 = GoogleFonts.manrope(
    fontSize: 24,
    fontWeight: FontWeight.w900,
    color: Colors.white,
  );
  static final TextStyle h4 = GoogleFonts.manrope(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static final TextStyle regular_24 = GoogleFonts.manrope(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    color: Colors.white,
  );
  static final TextStyle medium_12 = GoogleFonts.manrope(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: Colors.white,
  );

  static final TextStyle michroma = GoogleFonts.michroma(
    fontSize: 24,
    fontWeight: FontWeight.w500,
    color: Colors.white,
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

  static final TextStyle timer = GoogleFonts.manrope(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );
  static final TextStyle filterText = GoogleFonts.poppins(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    fontStyle: FontStyle.italic,
    color: Colors.white,
  );
}
