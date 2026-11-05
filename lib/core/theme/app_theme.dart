
import 'package:flutter/material.dart';

import 'package:movie_discovery_app/core/theme/app_fonts.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/core/utils/app_styles.dart';

class AppTheme {
  static final ThemeData lightTheme = _build(Brightness.light);
  static final ThemeData darkTheme = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;

    final background = isDark
        ? AppColors.bgDarkColor
        : AppColors.bgLightColor;

    final text = isDark
        ? AppColors.textDarkColor
        : AppColors.textLightColor;

    final secondary = isDark
        ? AppColors.secondaryTextDarkColor
        : AppColors.secondaryTextLightColor;

    final card = isDark
        ? AppColors.cardDarkColor
        : AppColors.fieldWhiteColor;

    final border = isDark
        ? AppColors.borderDarkColor
        : AppColors.borderLightColor;

    final primary = isDark
        ? AppColors.primaryTextDarkColor
        : AppColors.primaryColor;

    return ThemeData(
      brightness: brightness,
      fontFamily: AppFonts.family,
      fontFamilyFallback: const [AppFonts.arabicFamily],

      scaffoldBackgroundColor: background,
      primaryColor: AppColors.primaryColor,

      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        brightness: brightness,
        primary: primary,
        onPrimary: isDark ? AppColors.bgDarkColor : AppColors.whiteColor,
        surface: card,
        onSurface: text,
        onSurfaceVariant: secondary,
        error: isDark
            ? AppColors.errorDarkColor
            : AppColors.errorLightColor,
      ),

      textTheme: TextTheme(
        titleLarge: isDark
            ? AppStyles.bold20White
            : AppStyles.bold20DarkBlue,
        titleMedium: AppStyles.bold20Primary,
        titleSmall: AppStyles.med14White,
        bodyLarge: isDark
            ? AppStyles.bold22White
            : AppStyles.bold22DarkBlue,
        bodyMedium: isDark
            ? AppStyles.reg14HintDark
            : AppStyles.reg14HintLight,
        bodySmall: isDark
            ? AppStyles.reg12LightGray
            : AppStyles.reg12DarkGray,
        displayLarge: isDark
            ? AppStyles.med14White
            : AppStyles.med14DarkGray,
        displayMedium: AppStyles.med12Primary,
      ).apply(
        bodyColor: text,
        displayColor: text,
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),

      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: border),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark
            ? AppColors.fieldDarkBlueColor
            : AppColors.fieldWhiteColor,
        hintStyle: isDark
            ? AppStyles.reg14HintDark
            : AppStyles.reg14HintLight,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.whiteColor,
          textStyle: AppStyles.med14White,
          fixedSize: const Size(double.infinity, 48),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          elevation: 8,
          shadowColor: AppColors.primaryColor.withValues(alpha: 0.4),
        ),
      ),

      dividerTheme: DividerThemeData(
        color: border,
        thickness: 1,
        space: 1,
      ),

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: primary,
        unselectedItemColor: secondary,
        selectedLabelStyle: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: const TextStyle(fontSize: 11),
      ),
    );
  }
}
