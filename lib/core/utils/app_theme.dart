import 'package:flutter/material.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import '../theme/app_fonts.dart';
import 'app_styles.dart';

class AppTheme {
  static final lightTheme = _build(Brightness.light);
  static final darkTheme = _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final dark = brightness == Brightness.dark;
    final text = dark ? AppColors.textDarkColor : AppColors.textLightColor;
    final secondary = dark
        ? AppColors.secondaryTextDarkColor
        : AppColors.secondaryTextLightColor;
    final background = dark ? AppColors.bgDarkColor : AppColors.bgLightColor;
    final card = dark ? AppColors.cardDarkColor : Colors.white;
    final border = dark
        ? AppColors.borderDarkColor
        : AppColors.borderLightColor;

    return ThemeData(
      brightness: brightness,
      fontFamily: AppFonts.family,
      fontFamilyFallback: const [AppFonts.arabicFamily],
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryColor,
        brightness: brightness,
        primary: dark ? AppColors.primaryTextDarkColor : AppColors.primaryColor,
        onPrimary: dark ? AppColors.bgDarkColor : Colors.white,
        surface: card,
        onSurface: text,
        onSurfaceVariant: secondary,
        error: dark ? AppColors.errorDarkColor : AppColors.errorLightColor,
      ),
      textTheme:
          TextTheme(
                titleLarge: AppStyles.title,
                titleMedium: AppStyles.subtitle,
                bodyMedium: AppStyles.body,
                bodySmall: AppStyles.caption,
              )
              .apply(bodyColor: text, displayColor: text)
              .copyWith(
                bodySmall: AppStyles.caption.copyWith(color: secondary),
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
      dividerTheme: DividerThemeData(color: border, thickness: 1, space: 1),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: background,
        selectedItemColor: dark
            ? AppColors.primaryTextDarkColor
            : AppColors.primaryColor,
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
