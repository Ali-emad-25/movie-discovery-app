import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/core/utils/genre_helper.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/movie.dart';

class FeaturedHeroCard extends StatelessWidget {
  final Movie? movie;
  final VoidCallback? onWatch;
  final VoidCallback? onDetails;

  const FeaturedHeroCard({
    super.key,
    required this.movie,
    this.onWatch,
    this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    if (movie == null) return const SizedBox.shrink();

    final m = movie!;
    final lang = context.locale.languageCode;
    final genres = GenreHelper.getGenreNames(m.genreIds, languageCode: lang, limit: 2);

    return GestureDetector(
      onTap: onDetails,
      child: Container(
        height: 220.h,
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          color: const Color(0xFF171B26),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.35),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            if (m.backdropPath != null && m.backdropPath!.isNotEmpty)
              Image.network(
                m.backdropUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _placeholder(),
              )
            else if (m.posterPath != null && m.posterPath!.isNotEmpty)
              Image.network(
                m.posterUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => _placeholder(),
              )
            else
              _placeholder(),

            // Gradient scrim
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.3),
                    Colors.transparent,
                    Colors.black.withValues(alpha: 0.9),
                  ],
                  stops: const [0.0, 0.4, 1.0],
                ),
              ),
            ),

            // Top Badges
            Positioned(
              top: 12.h,
              left: 12.w,
              right: 12.w,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Featured Premiere Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD2BBFF).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(9999.r),
                      border: Border.all(
                        color: const Color(0xFFD2BBFF).withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'home.featured_premiere'.tr(),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.6,
                        color: const Color(0xFFD2BBFF),
                      ),
                    ),
                  ),

                  // Rating Badge
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.7),
                      borderRadius: BorderRadius.circular(9999.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: const Color(0xFFFFC107),
                          size: 14.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          m.ratingFormatted,
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Center Glowing Play Button
            Center(
              child: GestureDetector(
                onTap: onWatch ?? onDetails,
                child: Container(
                  width: 52.r,
                  height: 52.r,
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
                    size: 32.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

            // Bottom Info & Watch Button
            Positioned(
              left: 14.w,
              right: 14.w,
              bottom: 12.h,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Title + Metadata
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          m.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w800,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                [
                                  m.isTvShow
                                      ? 'home.tv_show'.tr()
                                      : 'home.movie'.tr(),
                                  if (m.releaseYear.isNotEmpty) m.releaseYear,
                                  if (genres.isNotEmpty) genres,
                                ].join(' • '),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  color: Colors.white.withValues(alpha: 0.8),
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 6.w,
                                vertical: 2.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.r),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                              ),
                              child: Text(
                                'home.quality_4k'.tr(),
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(width: 10.w),

                  // Watch Button
                  GestureDetector(
                    onTap: onWatch ?? onDetails,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(9999.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_arrow_rounded,
                            size: 16.sp,
                            color: Colors.white,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'home.watch'.tr(),
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFF1F2430),
      child: Center(
        child: Icon(
          Icons.movie_creation_outlined,
          size: 48.sp,
          color: Colors.white.withValues(alpha: 0.3),
        ),
      ),
    );
  }
}
