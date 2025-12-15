import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Define your main colors here
  static const primaryColor = Colors.blue;
  static const scaffoldColor = Color(0xFFF5F5F5);

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    primarySwatch: primaryColor,
    scaffoldBackgroundColor: scaffoldColor,

    // Define the global font family (Poppins is great for e-commerce)
    textTheme: GoogleFonts.poppinsTextTheme(),

    appBarTheme: const AppBarTheme(
      backgroundColor: primaryColor,
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
    ),
  );
}