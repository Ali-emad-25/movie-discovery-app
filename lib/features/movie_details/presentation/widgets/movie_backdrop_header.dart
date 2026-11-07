import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/movie_details/domain/entities/movie_details.dart';

class MovieBackdropHeader extends StatelessWidget {
  final MovieDetails movie;
  final VoidCallback onBack;
  final VoidCallback onBookmark;
  final VoidCallback onPlayTrailer;
  final bool isBookmarked;

  const MovieBackdropHeader({
    super.key,
    required this.movie,
    required this.onBack,
    required this.onBookmark,
    required this.onPlayTrailer,
    this.isBookmarked = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.bgDarkColor : AppColors.bgLightColor;
    final topPadding = MediaQuery.of(context).padding.top;

    return SizedBox(
      height: 320.h,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Backdrop Image
          if (movie.backdropPath != null && movie.backdropPath!.isNotEmpty)
            Image.network(
              movie.backdropUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _placeholder(isDark),
            )
          else if (movie.posterPath != null && movie.posterPath!.isNotEmpty)
            Image.network(
              movie.posterUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => _placeholder(isDark),
            )
          else
            _placeholder(isDark),

          // Gradient overlay top (for app bar buttons visibility)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 100.h,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Gradient overlay bottom (blends into screen background)
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            height: 180.h,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    bgColor.withValues(alpha: 0.6),
                    bgColor,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),

          // Play Trailer Button in Center
          if (movie.trailerKey != null && movie.trailerKey!.isNotEmpty)
            Center(
              child: GestureDetector(
                onTap: onPlayTrailer,
                child: Container(
                  width: 58.r,
                  height: 58.r,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primaryColor.withValues(alpha: 0.5),
                        blurRadius: 18,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white,
                    size: 34.sp,
                  ),
                ),
              ),
            ),

          // Top Action Buttons
          Positioned(
            top: topPadding + 6.h,
            left: 16.w,
            right: 16.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _circularButton(
                  icon: Icons.arrow_back_ios_new_rounded,
                  onTap: onBack,
                ),
                _circularButton(
                  icon: isBookmarked
                      ? Icons.bookmark_rounded
                      : Icons.bookmark_border_rounded,
                  color: isBookmarked ? AppColors.primaryColor : Colors.white,
                  onTap: onBookmark,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circularButton({
    required IconData icon,
    required VoidCallback onTap,
    Color color = Colors.white,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 42.r,
        height: 42.r,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.45),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        child: Icon(
          icon,
          color: color,
          size: 18.sp,
        ),
      ),
    );
  }

  Widget _placeholder(bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF151923) : const Color(0xFFE2E8F0),
      child: const Center(
        child: Icon(
          Icons.movie_creation_outlined,
          color: AppColors.primaryColor,
          size: 48,
        ),
      ),
    );
  }
}

