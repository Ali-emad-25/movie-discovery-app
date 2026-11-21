import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';

class FilterTabs extends StatelessWidget {
  final List<String> tabKeys;
  final int selectedIndex;
  final ValueChanged<int> onSelectTab;

  const FilterTabs({
    super.key,
    required this.tabKeys,
    required this.selectedIndex,
    required this.onSelectTab,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox(
      height: 36.h,
      child: ListView.separated(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        scrollDirection: Axis.horizontal,
        itemCount: tabKeys.length,
        separatorBuilder: (_, _) => SizedBox(width: 8.w),
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onSelectTab(index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primaryColor
                    : (isDark ? const Color(0xFF262A35) : const Color(0xFFE2E8F0)),
                borderRadius: BorderRadius.circular(9999.r),
              ),
              alignment: Alignment.center,
              child: Text(
                tabKeys[index].tr(),
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? Colors.white
                      : (isDark ? const Color(0xFFCCC3D8) : const Color(0xFF64748B)),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

