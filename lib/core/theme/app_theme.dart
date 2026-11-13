import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppColors {
  static const background = Color(0xFFF7F9FF);
  static const surface = Colors.white;
  static const darkNavy = Color(0xFF182442);
  static const primaryBlue = Color(0xFF1E40AF);
  static const accentYellow = Color(0xFFFCE18F);
  static const yellowBg = Color(0x33F59E0B);
  static const yellowBorder = Color(0x4DF59E0B);
  static const green = Color(0xFF10B981);
  static const greenBg = Color(0x1A10B981);
  static const greenBorder = Color(0x3310B981);
  static const grayText = Color(0xFF45464E);
  static const darkText = Color(0xFF161C23);
  static const lightGray = Color(0xFFE8EEF7);
  static const borderLight = Color(0xFFC6C6CE);
  static const lightBlueText = Color(0xFFBAC6EC);
  static const appBarBg = Color(0xFFF6F9FF);
  static const profileBg = Color(0xFFDBE3ED);

  static const drawerBg = Color(0xFFEDF4FE);
  static const drawerActiveBg = Color(0xFFBDDEFE);
  static const drawerActiveText = Color(0xFF43627E);
  static const brandLogoBg = Color(0xFF2E3A59);
  static const errorRed = Color(0xFFBA1A1A);
  static const idText = Color(0xFF42617D);
  static const planBadgeBg = Color(0x52C2C2C2);
  static const planBadgeText = Color(0xFF231B00);
}

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryBlue,
        surface: AppColors.background,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        headlineLarge: GoogleFonts.hankenGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.darkNavy,
          letterSpacing: -0.6,
        ),
      ),
    );
  }
}
