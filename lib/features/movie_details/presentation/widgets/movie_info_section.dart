import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/movie_details/domain/entities/movie_details.dart';

class MovieInfoSection extends StatelessWidget {
  final MovieDetails movie;
  final VoidCallback onWatchTrailer;

  const MovieInfoSection({
    super.key,
    required this.movie,
    required this.onWatchTrailer,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDarkColor : AppColors.textLightColor;
    final secondaryTextColor =
        isDark ? AppColors.secondaryTextDarkColor : AppColors.secondaryTextLightColor;
    final cardColor = isDark ? AppColors.cardDarkColor : AppColors.cardLightColor;
    final borderColor = isDark ? AppColors.borderDarkColor : AppColors.borderLightColor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster and Basic Details Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Poster Card
              Container(
                width: 105.w,
                height: 155.h,
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(color: borderColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: movie.posterPath != null && movie.posterPath!.isNotEmpty
                    ? Image.network(
                        movie.posterUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _posterPlaceholder(isDark),
                      )
                    : _posterPlaceholder(isDark),
              ),

              SizedBox(width: 16.w),

              // Title and Meta Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.4,
                      ),
                    ),

                    if (movie.tagline.isNotEmpty) ...[
                      SizedBox(height: 4.h),
                      Text(
                        movie.tagline,
                        style: TextStyle(
                          color: secondaryTextColor,
                          fontSize: 12.sp,
                          fontStyle: FontStyle.italic,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],

                    SizedBox(height: 10.h),

                    // Rating Pill
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 3.h,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFBBF24).withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(8.r),
                            border: Border.all(
                              color: const Color(0xFFFBBF24).withValues(alpha: 0.35),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: const Color(0xFFFBBF24),
                                size: 15.sp,
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                movie.ratingFormatted,
                                style: TextStyle(
                                  color: isDark ? Colors.white : const Color(0xFFB45309),
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '(${movie.voteCount} votes)',
                          style: TextStyle(
                            color: secondaryTextColor,
                            fontSize: 11.sp,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 8.h),

                    // Release Year & Runtime Chips
                    Wrap(
                      spacing: 8.w,
                      runSpacing: 4.h,
                      children: [
                        if (movie.releaseYear.isNotEmpty)
                          _metaChip(movie.releaseYear, isDark),
                        if (movie.formattedRuntime.isNotEmpty)
                          _metaChip(movie.formattedRuntime, isDark),
                        _metaChip('HD', isDark, isHighlight: true),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          SizedBox(height: 16.h),

          // Genres Chips
          if (movie.genres.isNotEmpty)
            Wrap(
              spacing: 8.w,
              runSpacing: 8.h,
              children: movie.genres.map((genre) {
                return Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 5.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.withValues(alpha: isDark ? 0.15 : 0.08),
                    borderRadius: BorderRadius.circular(20.r),
                    border: Border.all(
                      color: AppColors.primaryColor.withValues(alpha: isDark ? 0.35 : 0.2),
                    ),
                  ),
                  child: Text(
                    genre,
                    style: TextStyle(
                      color: isDark
                          ? AppColors.primaryTextDarkColor
                          : AppColors.primaryColor,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),

          SizedBox(height: 18.h),

          // Primary Watch Button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
                foregroundColor: Colors.white,
                elevation: 4,
                shadowColor: AppColors.primaryColor.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              onPressed: onWatchTrailer,
              icon: const Icon(Icons.play_circle_fill_rounded, size: 22),
              label: Text(
                movie.trailerKey != null && movie.trailerKey!.isNotEmpty
                    ? 'Watch Official Trailer'
                    : 'Watch Trailer',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.2,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _metaChip(String text, bool isDark, {bool isHighlight = false}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: isHighlight
            ? AppColors.primaryColor.withValues(alpha: 0.15)
            : (isDark ? const Color(0xFF1E2433) : const Color(0xFFEDF2F7)),
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isHighlight
              ? (isDark ? AppColors.primaryTextDarkColor : AppColors.primaryColor)
              : (isDark ? Colors.white70 : const Color(0xFF4A5568)),
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _posterPlaceholder(bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF1F2432) : const Color(0xFFF1F5F9),
      child: const Center(
        child: Icon(
          Icons.movie_outlined,
          color: AppColors.primaryColor,
          size: 32,
        ),
      ),
    );
  }
}

