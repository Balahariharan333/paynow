import 'package:flutter/material.dart';
import 'package:paynow/utils/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.light,
        primary: AppColors.primary,
        surface: AppColors.white,
        onSurface: AppColors.black,
        onSurfaceVariant: AppColors.grayFont,
      ),
      cardColor: AppColors.white,
      scaffoldBackgroundColor: AppColors.lightGray,
      useMaterial3: true,
      fontFamily: 'Valley Sans', 
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        brightness: Brightness.dark,
        primary: AppColors.primary,
        surface: const Color(0xFF1E293B),
        onSurface: AppColors.white,
        onSurfaceVariant: const Color(0xFF94A3B8),
      ),
      cardColor: const Color(0xFF1E293B),
      scaffoldBackgroundColor: const Color(0xFF0F172A),
      useMaterial3: true,
      fontFamily: 'Valley Sans',
    );
  }
}
