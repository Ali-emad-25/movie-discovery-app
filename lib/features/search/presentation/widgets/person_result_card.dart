import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/search/domain/entities/search_item.dart';

class PersonResultCard extends StatelessWidget {
  final SearchItem item;
  final VoidCallback onTap;

  const PersonResultCard({super.key, required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final textColor = isDark
        ? AppColors.textDarkColor
        : AppColors.textLightColor;

    final secondaryColor = isDark
        ? AppColors.secondaryTextDarkColor
        : AppColors.secondaryTextLightColor;

    final fieldColor = isDark
        ? AppColors.fieldDarkColor
        : AppColors.fieldLightColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 16),
        padding: EdgeInsets.all(15.r),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDarkColor : AppColors.cardLightColor,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            ClipOval(
              child: item.imageUrl.isEmpty
                  ? Container(
                      width: 70.w,
                      height: 70.w,
                      color: fieldColor,
                      child: Icon(
                        Icons.person_outline,
                        color: secondaryColor,
                        size: 30.sp,
                      ),
                    )
                  : Image.network(
                      item.imageUrl,
                      width: 70.w,
                      height: 70.w,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 65.w,
                        height: 65.w,
                        color: fieldColor,
                        child: Icon(
                          Icons.person_outline,
                          color: secondaryColor,
                          size: 28.sp,
                        ),
                      ),
                    ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 5.h),
                  Text(
                    item.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: secondaryColor, fontSize: 11.sp),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              color: secondaryColor,
              size: 14.sp,
            ),
          ],
        ),
      ),
    );
  }
}
