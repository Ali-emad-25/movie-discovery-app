import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/movie_details/domain/entities/movie_details.dart';

class MovieDetailsBentoGrid extends StatelessWidget {
  final MovieDetails movie;

  const MovieDetailsBentoGrid({
    super.key,
    required this.movie,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBg = isDark ? const Color(0xFF171B26) : Colors.white;
    final borderColor = isDark ? const Color(0xFF2A2F42) : const Color(0xFFE2E8F0);
    final textColor = isDark ? AppColors.textDarkColor : AppColors.textLightColor;
    final labelColor = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final lang = context.locale.languageCode;

    final director = movie.director.isNotEmpty
        ? movie.director
        : (lang == 'ar' ? 'غير متوفر' : 'N/A');
    final music = movie.musicComposer.isNotEmpty
        ? movie.musicComposer
        : (lang == 'ar' ? 'غير متوفر' : 'N/A');
    final boxOffice = movie.formattedCurrency(movie.revenue, lang);
    final budget = movie.formattedCurrency(movie.budget, lang);

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'movie_details.movie_details'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),

          SizedBox(height: 12.h),

          // 2x2 Grid
          Row(
            children: [
              Expanded(
                child: _buildBentoCell(
                  label: 'movie_details.director'.tr(),
                  value: director,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  labelColor: labelColor,
                  textColor: textColor,
                  isDark: isDark,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _buildBentoCell(
                  label: 'movie_details.box_office'.tr(),
                  value: boxOffice,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  labelColor: labelColor,
                  textColor: textColor,
                  isDark: isDark,
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),

          Row(
            children: [
              Expanded(
                child: _buildBentoCell(
                  label: 'movie_details.budget'.tr(),
                  value: budget,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  labelColor: labelColor,
                  textColor: textColor,
                  isDark: isDark,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: _buildBentoCell(
                  label: 'movie_details.original_music'.tr(),
                  value: music,
                  cardBg: cardBg,
                  borderColor: borderColor,
                  labelColor: labelColor,
                  textColor: textColor,
                  isDark: isDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBentoCell({
    required String label,
    required String value,
    required Color cardBg,
    required Color borderColor,
    required Color labelColor,
    required Color textColor,
    required bool isDark,
  }) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10.sp,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
              color: labelColor,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 13.5.sp,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
