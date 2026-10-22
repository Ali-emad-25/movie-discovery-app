import 'package:flutter/material.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.bgLightColor,
  );
  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: AppColors.bgDarkColor,
  );
}
