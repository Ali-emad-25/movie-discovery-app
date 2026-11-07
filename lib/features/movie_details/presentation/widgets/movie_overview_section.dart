import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';

class MovieOverviewSection extends StatefulWidget {
  final String overview;

  const MovieOverviewSection({
    super.key,
    required this.overview,
  });

  @override
  State<MovieOverviewSection> createState() => _MovieOverviewSectionState();
}

class _MovieOverviewSectionState extends State<MovieOverviewSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    if (widget.overview.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDarkColor : AppColors.textLightColor;
    final secondaryTextColor =
        isDark ? AppColors.secondaryTextDarkColor : AppColors.secondaryTextLightColor;

    final isLong = widget.overview.length > 180;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Storyline',
            style: TextStyle(
              color: textColor,
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            widget.overview,
            maxLines: _isExpanded ? null : 4,
            overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
            style: TextStyle(
              color: secondaryTextColor,
              fontSize: 13.5.sp,
              height: 1.55,
            ),
          ),
          if (isLong) ...[
            SizedBox(height: 4.h),
            GestureDetector(
              onTap: () {
                setState(() {
                  _isExpanded = !_isExpanded;
                });
              },
              child: Text(
                _isExpanded ? 'Read Less' : 'Read More',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 12.5.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
