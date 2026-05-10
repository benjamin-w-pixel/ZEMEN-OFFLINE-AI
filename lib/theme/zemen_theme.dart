import 'package:flutter/material.dart';

class ZemenTheme {
  static const Color satinGold = Color(0xFFFFD700);
  static const Color obsidian = Color(0xFF0A192C);
  static const Color subtleGray = Color(0xFF1F1F1F);
  static const Color accentBlue = Color(0xFF4A90E2);

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: obsidian,
    primaryColor: satinGold,
    colorScheme: const ColorScheme.dark(
      primary: satinGold,
      secondary: accentBlue,
      background: obsidian,
      surface: subtleGray,
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      bodyLarge: TextStyle(color: Colors.white),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: obsidian,
      foregroundColor: Colors.white,
    ),
  );
}
