import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/movie_details/domain/entities/movie_details.dart';

class MovieDetailsHero extends StatelessWidget {
  final MovieDetails movie;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback onPlayTrailer;

  const MovieDetailsHero({
    super.key,
    required this.movie,
    required this.isFavorite,
    required this.onToggleFavorite,
    required this.onPlayTrailer,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F131D) : const Color(0xFFF8FAFC);

    return AspectRatio(
      aspectRatio: 16 / 10,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Backdrop Image
          if (movie.backdropPath != null && movie.backdropPath!.isNotEmpty)
            Image.network(
              movie.backdropUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _placeholder(),
            )
          else if (movie.posterPath != null && movie.posterPath!.isNotEmpty)
            Image.network(
              movie.posterUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _placeholder(),
            )
          else
            _placeholder(),

          // Deep Vignette Gradient
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.5),
                  Colors.transparent,
                  bgColor.withValues(alpha: 0.7),
                  bgColor,
                ],
                stops: const [0.0, 0.35, 0.75, 1.0],
              ),
            ),
          ),

          // Floating Badges Row (Top Left & Top Right)
          Positioned(
            top: 12.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // 'IN CINEMAS & IMAX' badge
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.65),
                    borderRadius: BorderRadius.circular(9999.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.15),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 6.r,
                        height: 6.r,
                        decoration: const BoxDecoration(
                          color: Color(0xFFFBBF24), // Amber dot
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'movie_details.in_cinemas'.tr(),
                        style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.4,
                        ),
                      ),
                    ],
                  ),
                ),

                // Favorite Heart Button
                GestureDetector(
                  onTap: onToggleFavorite,
                  child: Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.65),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.15),
                      ),
                    ),
                    child: Icon(
                      isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                      color: isFavorite ? const Color(0xFFFF383C) : Colors.white,
                      size: 20.sp,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Central Glowing Play Button
          Center(
            child: GestureDetector(
              onTap: onPlayTrailer,
              child: Container(
                width: 56.r,
                height: 56.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.55),
                      blurRadius: 18,
                      spreadRadius: 3,
                    ),
                  ],
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 34.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Bottom Right '4K Ultra HD' badge
          Positioned(
            bottom: 12.h,
            right: 16.w,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.65),
                borderRadius: BorderRadius.circular(6.r),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.tv_rounded,
                    color: Colors.white,
                    size: 13.sp,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    'movie_details.quality_4k'.tr(),
                    style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFFE2E8F0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFF171B26),
      child: Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: AppColors.primaryColor.withValues(alpha: 0.5),
          size: 48.sp,
        ),
      ),
    );
  }
}

