import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';

class HomeSectionHeader extends StatelessWidget {
  final String title;
  final Color accentColor;
  final VoidCallback? onSeeAll;
  final Widget? trailing;

  const HomeSectionHeader({
    super.key,
    required this.title,
    required this.accentColor,
    this.onSeeAll,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // Vertical Accent Bar
          Container(
            width: 5.w,
            height: 18.h,
            decoration: BoxDecoration(
              color: accentColor,
              borderRadius: BorderRadius.circular(9999.r),
            ),
          ),
          SizedBox(width: 8.w),

          // Title
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
                color: isDark ? AppColors.textDarkColor : AppColors.textLightColor,
              ),
            ),
          ),

          // Trailing widget or See All
          if (trailing != null)
            trailing!
          else if (onSeeAll != null)
            GestureDetector(
              onTap: onSeeAll,
              behavior: HitTestBehavior.opaque,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'home.see_all'.tr(),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFFD2BBFF) : AppColors.primaryColor,
                    ),
                  ),
                  SizedBox(width: 2.w),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 16.sp,
                    color: isDark ? const Color(0xFFD2BBFF) : AppColors.primaryColor,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

