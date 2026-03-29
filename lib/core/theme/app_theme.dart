import 'package:flutter/material.dart';

class AppTheme {
  static const Color primaryGreen = Color(0xFF8EE53F);
  static const Color lightGreen = Color(0xFFD4F4A8);
  static const Color darkGreen = Color(0xFF5CB82C);
  static const Color background = Color(0xFFF0F7E6);
  static const Color cardBackground = Colors.white;
  static const Color textPrimary = Color(0xFF1A1A1A);
  static const Color textSecondary = Color(0xFF666666);
  static const Color proteinColor = Color(0xFFFFB6C1);
  static const Color carbsColor = Color(0xFFFFE4B5);
  static const Color fatColor = Color(0xFF87CEEB);

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: primaryGreen,
      scaffoldBackgroundColor: background,
      fontFamily: 'SF Pro Display',
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textPrimary),
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: cardBackground,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: primaryGreen,
        unselectedItemColor: textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 10,
      ),
    );
  }
}
