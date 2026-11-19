import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';

class SearchEmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final String? action;
  final VoidCallback? onAction;

  const SearchEmptyState({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColors.primaryTextDarkColor
        : AppColors.primaryColor;
    final fieldColor = isDark
        ? AppColors.fieldDarkColor
        : AppColors.fieldLightColor;
    final textColor = isDark
        ? AppColors.textDarkColor
        : AppColors.textLightColor;
    final secondaryColor = isDark
        ? AppColors.secondaryTextDarkColor
        : AppColors.secondaryTextLightColor;

    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 34.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 112.r,
                  height: 112.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: primaryColor.withValues(alpha: .16),
                    boxShadow: [
                      BoxShadow(
                        color: primaryColor.withValues(alpha: .26),
                        blurRadius: 34,
                        spreadRadius: 5,
                      ),
                    ],
                  ),
                  child: Icon(icon, color: primaryColor, size: 38.sp),
                ),
                SizedBox(height: 38.h),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            if (subtitle != null) ...[
              SizedBox(height: 8.h),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: TextStyle(color: secondaryColor, fontSize: 10.sp),
              ),
            ],
            if (action != null && onAction != null) ...[
              SizedBox(height: 12.h),
              TextButton.icon(
                onPressed: onAction,
                icon: Icon(
                  Icons.refresh_rounded,
                  size: 12.sp,
                  color: primaryColor,
                ),
                label: Text(
                  action!,
                  style: TextStyle(color: primaryColor, fontSize: 9.sp),
                ),
                style: TextButton.styleFrom(
                  backgroundColor: fieldColor,
                  padding: EdgeInsets.symmetric(
                    horizontal: 13.w,
                    vertical: 6.h,
                  ),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
