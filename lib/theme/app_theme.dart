import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WaqtiTheme {
  // Palette — warm sky blue primary, golden star accent, soft coral for fun
  static const Color primaryBlue = Color(0xFF1976D2);
  static const Color lightBlue = Color(0xFF64B5F6);
  static const Color skyBlue = Color(0xFFE3F2FD);
  static const Color starGold = Color(0xFFFFC107);
  static const Color sunYellow = Color(0xFFFFF176);
  static const Color coral = Color(0xFFFF7043);
  static const Color mint = Color(0xFF4CAF50);
  static const Color lilac = Color(0xFF7C4DFF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color offWhite = Color(0xFFF8FBFF);
  static const Color textDark = Color(0xFF0D1B2A);
  static const Color textMid = Color(0xFF37474F);

  // Unit colors
  static const List<Color> unitColors = [
    Color(0xFF1976D2), // Unit 1 - Blue
    Color(0xFF7C4DFF), // Unit 2 - Purple
    Color(0xFF00897B), // Unit 3 - Teal
    Color(0xFFFF7043), // Unit 4 - Coral
    Color(0xFFD81B60), // Unit 5 - Pink
  ];

  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primaryBlue,
          brightness: Brightness.light,
        ),
        textTheme: GoogleFonts.cairoTextTheme().copyWith(
          displayLarge: GoogleFonts.cairo(
            fontSize: 48,
            fontWeight: FontWeight.w800,
            color: textDark,
          ),
          displayMedium: GoogleFonts.cairo(
            fontSize: 36,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
          headlineLarge: GoogleFonts.cairo(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
          headlineMedium: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: textDark,
          ),
          bodyLarge: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: textDark,
          ),
          bodyMedium: GoogleFonts.cairo(
            fontSize: 16,
            color: textMid,
          ),
          labelLarge: GoogleFonts.cairo(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: white,
          ),
        ),
        scaffoldBackgroundColor: offWhite,
        appBarTheme: AppBarTheme(
          backgroundColor: primaryBlue,
          foregroundColor: white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: GoogleFonts.cairo(
            fontSize: 22,
            fontWeight: FontWeight.w700,
            color: white,
          ),
        ),
      );
}
