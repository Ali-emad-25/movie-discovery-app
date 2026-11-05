import 'package:flutter/material.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/core/utils/app_styles.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColors.bgLightColor,
    primaryColor: AppColors.primaryColor,

    colorScheme: const ColorScheme.light(
      primary: AppColors.primaryColor,
      onPrimary: AppColors.darkGrayColor,
      surface: AppColors.fieldWhiteColor,
      onSecondary: AppColors.fieldGrayColor,
    ),

    textTheme: TextTheme(
      titleLarge: AppStyles.bold20DarkBlue,
      titleMedium: AppStyles.bold20Primary,
      titleSmall: AppStyles.med14White,
      bodyLarge: AppStyles.bold22DarkBlue,
      bodyMedium: AppStyles.reg14HintLight,
      bodySmall: AppStyles.reg12DarkGray,
      displayLarge: AppStyles.med14DarkGray,
      displayMedium: AppStyles.med12Primary,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.fieldWhiteColor,
      hintStyle: AppStyles.reg14HintLight,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: const BorderSide(
          color: AppColors.borderLightColor,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        textStyle: AppStyles.med14White,
        fixedSize: Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        elevation: 8,
        shadowColor: AppColors.primaryColor.withValues(alpha: 0.4),
      ),
    ),

    dividerColor: AppColors.borderLightColor,
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.bgDarkColor,
    primaryColor: AppColors.primaryColor,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.primaryColor,
      onPrimary: AppColors.lightGrayColor,
      surface: AppColors.fieldDarkBlueColor,
      onSecondary: AppColors.darkGrayColor,
    ),

    textTheme: TextTheme(
      titleLarge: AppStyles.bold20White,
      titleMedium: AppStyles.bold20Primary,
      titleSmall: AppStyles.med14White,
      bodyLarge: AppStyles.bold22White,
      bodyMedium: AppStyles.reg14HintDark,
      bodySmall: AppStyles.reg12LightGray,
      displayLarge: AppStyles.med14White,
      displayMedium: AppStyles.med12Primary,
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.fieldDarkBlueColor,
      hintStyle: AppStyles.reg14HintDark,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: const BorderSide(
          color: AppColors.borderDarkColor,
          width: 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(999),
        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1),
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primaryColor,
        foregroundColor: AppColors.whiteColor,
        textStyle: AppStyles.med14White,
        elevation: 8,
        fixedSize: Size(double.infinity, 48),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
        shadowColor: AppColors.primaryColor.withValues(alpha: 0.4),
      ),
    ),

    dividerColor: AppColors.borderDarkColor,
  );
}
