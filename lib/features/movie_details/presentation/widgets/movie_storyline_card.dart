import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';

class MovieStorylineCard extends StatefulWidget {
  final String overview;

  const MovieStorylineCard({
    super.key,
    required this.overview,
  });

  @override
  State<MovieStorylineCard> createState() => _MovieStorylineCardState();
}

class _MovieStorylineCardState extends State<MovieStorylineCard> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.overview.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF171B26) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A2F42) : const Color(0xFFE2E8F0);
    final textColor = isDark ? AppColors.textDarkColor : AppColors.textLightColor;
    final secondaryTextColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569);
    final accentColor = isDark ? const Color(0xFFD2BBFF) : AppColors.primaryColor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              'movie_details.storyline'.tr(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: textColor,
              ),
            ),

            SizedBox(height: 8.h),

            // Overview Body
            AnimatedCrossFade(
              firstChild: Text(
                widget.overview,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  height: 1.5,
                  color: secondaryTextColor,
                ),
              ),
              secondChild: Text(
                widget.overview,
                style: TextStyle(
                  fontSize: 13.5.sp,
                  height: 1.5,
                  color: secondaryTextColor,
                ),
              ),
              crossFadeState: _isExpanded
                  ? CrossFadeState.showSecond
                  : CrossFadeState.showFirst,
              duration: const Duration(milliseconds: 250),
            ),

            if (widget.overview.length > 120) ...[
              SizedBox(height: 6.h),
              GestureDetector(
                onTap: () {
                  setState(() {
                    _isExpanded = !_isExpanded;
                  });
                },
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _isExpanded
                          ? 'movie_details.show_less'.tr()
                          : 'movie_details.read_more'.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Icon(
                      _isExpanded
                          ? Icons.keyboard_arrow_up_rounded
                          : Icons.keyboard_arrow_down_rounded,
                      size: 16.sp,
                      color: accentColor,
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

