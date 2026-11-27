import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';

class AccountActionRow extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool isDark;
  final bool isDestructive;
  final VoidCallback? onTap;

  const AccountActionRow({
    super.key,
    required this.title,
    required this.icon,
    required this.isDark,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = isDestructive
        ? Theme.of(context).colorScheme.error
        : (isDark ? AppColors.textDarkColor : AppColors.textLightColor);
    final iconColor = isDestructive
        ? Theme.of(context).colorScheme.error
        : (isDark
              ? AppColors.secondaryTextDarkColor
              : AppColors.secondaryTextLightColor);
    final iconBackground = isDark
        ? AppColors.borderDarkColor
        : AppColors.borderLightColor;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          height: 84.h,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Row(
              children: [
                Container(
                  width: 48.r,
                  height: 48.r,
                  decoration: BoxDecoration(
                    color: iconBackground,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  child: Icon(icon, size: 23.sp, color: iconColor),
                ),
                SizedBox(width: 17.w),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: textColor,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  size: 22.sp,
                  color: isDestructive
                      ? textColor
                      : (isDark
                            ? AppColors.secondaryTextDarkColor
                            : AppColors.secondaryTextLightColor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
