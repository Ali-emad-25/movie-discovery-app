import 'dart:ui' as ui;
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/movie_details/domain/entities/movie_details.dart';

class MovieDetailsHeaderBlock extends StatelessWidget {
  final MovieDetails movie;

  const MovieDetailsHeaderBlock({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDarkColor : AppColors.textLightColor;
    final secondaryTextColor =
        isDark ? AppColors.secondaryTextDarkColor : AppColors.secondaryTextLightColor;
    final pillBg = isDark ? const Color(0xFF171B26) : Colors.white;
    final chipBg = isDark ? const Color(0xFF1E2230) : const Color(0xFFE2E8F0);
    final borderColor = isDark ? const Color(0xFF2A2F42) : const Color(0xFFCBD5E1);
    final lang = context.locale.languageCode;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title + Score Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title and Year/Runtime
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w800,
                        color: textColor,
                        height: 1.2,
                        letterSpacing: -0.5,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      [
                        if (movie.releaseYear.isNotEmpty) movie.releaseYear,
                        if (movie.runtime > 0) movie.formattedRuntime(lang),
                      ].join(' • '),
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w500,
                        color: secondaryTextColor,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 12.w),

              // Live TMDB Score Pill
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: pillBg,
                  borderRadius: BorderRadius.circular(9999.r),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Directionality(
                  textDirection: ui.TextDirection.ltr,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: const Color(0xFFFFC107),
                        size: 16.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        movie.ratingFormatted,
                        style: TextStyle(
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                      Text(
                        '/10',
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          color: secondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 14.h),

          // Genre Chips Wrap
          Wrap(
            spacing: 8.w,
            runSpacing: 8.h,
            children: [
              ...movie.genres.map(
                (genre) => Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: chipBg,
                    borderRadius: BorderRadius.circular(9999.r),
                    border: Border.all(color: borderColor),
                  ),
                  child: Text(
                    genre,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: isDark ? const Color(0xFFDFE2F1) : const Color(0xFF334155),
                    ),
                  ),
                ),
              ),
              if (movie.collectionName != null &&
                  movie.collectionName!.isNotEmpty)
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: pillBg,
                    borderRadius: BorderRadius.circular(9999.r),
                    border: Border.all(color: borderColor),
                  ),
                  child: Text(
                    movie.collectionName!,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w500,
                      color: secondaryTextColor,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

