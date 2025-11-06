import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    brightness: Brightness.light,
    primarySwatch: Colors.indigo,
    scaffoldBackgroundColor: Colors.white,
    textTheme: GoogleFonts.poppinsTextTheme(),
    appBarTheme: const AppBarTheme(elevation: 0, backgroundColor: Colors.transparent, foregroundColor: Colors.white),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

class WeatherColors {
  static const clearStart = Color(0xFF56CCF2);
  static const clearEnd = Color(0xFF2F80ED);
  static const cloudStart = Color(0xFFBDCCD6);
  static const cloudEnd = Color(0xFF7B8A93);
  static const rainStart = Color(0xFF5D9CEC);
  static const rainEnd = Color(0xFF2C3E50);
  static const thunderStart = Color(0xFF3A1C71);
  static const thunderEnd = Color(0xFF000000);
  static const snowStart = Color(0xFFE6F0FA);
  static const snowEnd = Color(0xFFBBDDF2);
  static const mistStart = Color(0xFFBBD4DE);
  static const mistEnd = Color(0xFF91A6B8);
}
