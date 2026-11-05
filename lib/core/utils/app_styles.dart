
import 'package:flutter/material.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';

class AppStyles {
  // Basic Text Styles
  static const title = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
  );

  static const subtitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
  );

  static const body = TextStyle(
    fontSize: 14,
    height: 1.5,
  );

  static const caption = TextStyle(
    fontSize: 12,
    height: 1.5,
  );

  // Regular Text Styles
  static TextStyle reg16DarkBlue = TextStyle(
    fontWeight: FontWeight.w400,
    fontSize: 16,
    color: AppColors.darkBlueColor,
  );

  static TextStyle reg12DarkGray = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: AppColors.darkGrayColor,
  );

  static TextStyle reg12LightGray = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 12,
    color: AppColors.lightGrayColor,
  );

  static TextStyle reg14HintLight = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: AppColors.hintLightColor,
  );

  static TextStyle reg14HintDark = TextStyle(
    fontWeight: FontWeight.normal,
    fontSize: 14,
    color: AppColors.hintDarkColor,
  );

  // Bold Text Styles
  static TextStyle bold20DarkBlue = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: AppColors.darkBlueColor,
  );

  static TextStyle bold20White = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: AppColors.whiteColor,
  );

  static TextStyle bold20Primary = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 20,
    color: AppColors.primaryColor,
  );

  static TextStyle bold22DarkBlue = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: AppColors.darkBlueColor,
  );

  static TextStyle bold22White = TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 22,
    color: AppColors.whiteColor,
  );

  // Medium Text Styles
  static TextStyle med12Primary = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 12,
    color: AppColors.primaryColor,
  );

  static TextStyle med14White = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.whiteColor,
  );

  static TextStyle med14DarkGray = TextStyle(
    fontWeight: FontWeight.w500,
    fontSize: 14,
    color: AppColors.darkGrayColor,
  );
}
