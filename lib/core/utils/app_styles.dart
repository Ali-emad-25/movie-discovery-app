import 'package:flutter/material.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';

class AppStyles {
  static const title = TextStyle(fontSize: 24, fontWeight: FontWeight.w700);
  static const subtitle = TextStyle(fontSize: 18, fontWeight: FontWeight.w600);
  static const body = TextStyle(fontSize: 14, height: 1.5);
  static const caption = TextStyle(fontSize: 12, height: 1.5);

  static TextStyle reg16DarkBlue = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColors.darkBlueColor,
  );
}
