import 'package:flutter/material.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/core/utils/app_text_styles.dart';

class AppTheme {
  AppTheme._();

  static final lightTheme = _build(Brightness.light);
  static final darkTheme = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;

    final background = dark ? AppColors.bgDarkColor : AppColors.bgLightColor;

    final card = dark ? AppColors.cardDarkColor : AppColors.cardLightColor;

    final text = dark ? AppColors.textDarkColor : AppColors.textLightColor;

    final secondaryText = dark
        ? AppColors.secondaryTextDarkColor
        : AppColors.secondaryTextLightColor;

    final primaryText = dark
        ? AppColors.primaryTextDarkColor
        : AppColors.primaryColor;

    final border = dark
        ? AppColors.borderDarkColor
        : AppColors.borderLightColor;

    final hint = dark ? AppColors.hintDarkColor : AppColors.hintLightColor;

    final error = dark ? AppColors.errorDarkColor : AppColors.errorLightColor;

    final divider = dark
        ? AppColors.dividerDarkColor
        : AppColors.dividerLightColor;

    final field = dark ? AppColors.fieldDarkColor : AppColors.fieldLightColor;

    final buttonText = dark ? AppColors.bgDarkColor : Colors.white;

    return ThemeData(
      brightness: brightness,

      primaryColor: AppColors.primaryColor,
      scaffoldBackgroundColor: background,

      colorScheme: ColorScheme(
        brightness: brightness,
        primary: dark ? AppColors.primaryTextDarkColor : AppColors.primaryColor,
        onPrimary: buttonText,
        secondary: AppColors.primaryColor,
        onSecondary: Colors.white,
        surface: card,
        onSurface: text,
        error: error,
        onError: Colors.white,
      ),

      textTheme: TextTheme(
        headlineLarge: AppTextStyles.splashTitle.copyWith(color: text),
        titleLarge: AppTextStyles.title.copyWith(color: text),
        titleMedium: AppTextStyles.heading.copyWith(color: text),
        titleSmall: AppTextStyles.subtitle.copyWith(color: primaryText),
        bodyLarge: AppTextStyles.bodyMedium.copyWith(color: text),
        bodyMedium: AppTextStyles.body.copyWith(color: text),
        bodySmall: AppTextStyles.caption.copyWith(color: secondaryText),
        labelLarge: AppTextStyles.button.copyWith(color: buttonText),
      ),

      appBarTheme: AppBarTheme(
        backgroundColor: background,
        foregroundColor: text,
        elevation: 0,
        centerTitle: false,
      ),

      cardTheme: CardThemeData(
        color: card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: border),
        ),
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: field,
        hintStyle: TextStyle(color: hint),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: const BorderSide(
            color: AppColors.primaryColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(999),
          borderSide: BorderSide(color: error, width: 1.5),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: Colors.white,
          elevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999),
          ),
          shadowColor: dark
              ? AppColors.primaryTextDarkColor.withValues(alpha: 0.40)
              : AppColors.primaryColor.withValues(alpha: 0.40),
        ),
      ),

      dividerColor: divider,

      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: card,
        selectedItemColor: primaryText,
        unselectedItemColor: secondaryText,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),
    );
  }
}
