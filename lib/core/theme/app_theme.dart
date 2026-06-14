import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../gen/fonts.gen.dart';
import 'colors.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: Colors.white,
    primaryColor: AppColors.Primary,
    colorScheme: ColorScheme.light(
      primary: AppColors.Primary,
      secondary: AppColors.Secondary,
      surface: Colors.white,
      error: AppColors.Error,
    ),
    fontFamily: FontFamily.montserrat,
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: AppColors.Secondary,
      elevation: 0,
    ),
    cardColor: Colors.white,
    dividerColor: Colors.grey.withOpacity(0.2),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: DarkColors.scaffoldBackground,
    primaryColor: AppColors.Primary,
    colorScheme: ColorScheme.dark(
      primary: AppColors.Primary,
      secondary: DarkColors.textPrimary,
      surface: DarkColors.cardBackground,
      error: AppColors.Error,
    ),
    fontFamily: FontFamily.montserrat,
    appBarTheme: AppBarTheme(
      backgroundColor: DarkColors.scaffoldBackground,
      foregroundColor: DarkColors.textPrimary,
      elevation: 0,
    ),
    cardColor: DarkColors.cardBackground,
    dividerColor: DarkColors.divider,
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: DarkColors.bottomNavBackground,
    ),
  );
}
