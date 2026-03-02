import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light Theme Colors
  static const Color dairyMartBlue = Color(0xFF0077B6);
  static const Color freshGreen = Color(0xFF10B981);
  static const Color lightBackground = Color(0xFFF8F9FA);

  // Dark Theme Colors (Premium OLED Mode)
  static const Color deepBlack = Color(0xFF000000);
  static const Color surfaceGrey = Color(0xFF121212); // Greyscale 900
  static const Color indigoAccent = Color(0xFF6366F1); // Modern Indigo
  static const Color emeraldAccent = Color(0xFF10B981);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: dairyMartBlue,
    scaffoldBackgroundColor: lightBackground,
    cardColor: Colors.white,
    fontFamily: GoogleFonts.poppins().fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: dairyMartBlue,
      brightness: Brightness.light,
      primary: dairyMartBlue,
      secondary: freshGreen,
      surface: Colors.white,
      onSurface: Colors.black87,
      onPrimary: Colors.white,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.black87),
      titleTextStyle: TextStyle(color: Colors.black87, fontSize: 18, fontWeight: FontWeight.bold),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: dairyMartBlue,
      unselectedItemColor: Colors.grey,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      hintStyle: const TextStyle(color: Colors.grey),
    ),
    cardTheme: CardThemeData(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: indigoAccent,
    scaffoldBackgroundColor: deepBlack,
    cardColor: surfaceGrey,
    fontFamily: GoogleFonts.poppins().fontFamily,
    colorScheme: ColorScheme.fromSeed(
      seedColor: indigoAccent,
      brightness: Brightness.dark,
      primary: indigoAccent,
      secondary: emeraldAccent,
      surface: surfaceGrey,
      onSurface: Colors.white,
      onPrimary: Colors.white,
      background: deepBlack,
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: deepBlack,
      elevation: 0,
      centerTitle: true,
      surfaceTintColor: Colors.transparent,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: deepBlack,
      selectedItemColor: indigoAccent,
      unselectedItemColor: Colors.white54,
      elevation: 8,
      type: BottomNavigationBarType.fixed,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surfaceGrey,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
      hintStyle: const TextStyle(color: Colors.white38),
    ),
    cardTheme: CardThemeData(
      color: surfaceGrey,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
  );
}