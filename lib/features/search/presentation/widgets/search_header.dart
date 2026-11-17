import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';

class SearchHeader extends StatelessWidget {
  final bool isArabic;

  const SearchHeader({super.key, required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textDarkColor
        : AppColors.textLightColor;
    final primaryColor = isDark
        ? AppColors.primaryTextDarkColor
        : AppColors.primaryColor;
    final dividerColor = isDark
        ? AppColors.dividerDarkColor
        : AppColors.dividerLightColor;

    return Container(
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 0, 16.w, 0),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: dividerColor)),
      ),
      child: SizedBox(
        height: 66.h,
        child: Row(
          children: [
            IconButton(
              onPressed: () => Navigator.maybePop(context),
              padding: EdgeInsets.zero,
              constraints: BoxConstraints.tightFor(width: 32.w, height: 36.h),
              icon: Icon(
                isArabic
                    ? Icons.arrow_forward_rounded
                    : Icons.arrow_back_rounded,
                color: textColor,
                size: 21.sp,
              ),
            ),
            SizedBox(width: 13.w),
            Container(
              width: 32.r,
              height: 32.r,
              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: .22),
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Icon(
                Icons.search_rounded,
                color: primaryColor,
                size: 17.sp,
              ),
            ),
            SizedBox(width: 7.w),
            Expanded(
              child: Text(
                isArabic ? 'بحث' : 'Search',
                style: TextStyle(
                  color: textColor,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            CircleAvatar(
              radius: 18.r,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.person_outline,
                color: Colors.white,
                size: 25.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
