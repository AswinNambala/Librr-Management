import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData get darkTheme => ThemeData(
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF0F2027),
      secondary: Color(0xFF831010),
      surface: Color(0xFF2C5364),
      surfaceTint: Colors.grey,
      onSurface: Color(0xFF141414),
      onTertiary: Color(0xFF000000),
      tertiary: Color(0xFFFFA500),
      error: Color(0xFFE74C3C),
    ),
    brightness: Brightness.dark,
    iconTheme: const IconThemeData(color: Colors.white),
    cardTheme: CardTheme(
        elevation: 8,
        color: const Color(0xFF3E5C76),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
    textTheme: TextTheme(
        headlineMedium: GoogleFonts.inter(
            fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
        headlineSmall: GoogleFonts.inter(
            fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
        titleLarge: GoogleFonts.inter(
            fontSize: 22, fontWeight: FontWeight.w600, color: Colors.white),
        titleMedium: GoogleFonts.inter(
            fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.inter(
            fontSize: 16, fontWeight: FontWeight.w400, color: Colors.white),
        bodySmall: GoogleFonts.inter(fontSize: 14, color: Colors.white),
        labelSmall: GoogleFonts.inter(fontSize: 12, color: Colors.white),
        titleSmall: GoogleFonts.inter(fontSize: 10, color: Colors.white)));
