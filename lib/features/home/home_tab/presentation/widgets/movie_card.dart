import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/core/utils/genre_helper.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/movie.dart';

class MovieCard extends StatefulWidget {
  final Movie movie;
  final VoidCallback? onTap;

  const MovieCard({
    super.key,
    required this.movie,
    this.onTap,
  });

  @override
  State<MovieCard> createState() => _MovieCardState();
}

class _MovieCardState extends State<MovieCard> {
  bool _isBookmarked = false;

  void _toggleBookmark() {
    setState(() {
      _isBookmarked = !_isBookmarked;
    });
    Fluttertoast.showToast(
      msg: _isBookmarked
          ? 'home.added_to_watchlist'.tr()
          : 'home.removed_from_watchlist'.tr(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF171B26),
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDarkColor : AppColors.textLightColor;
    final secondaryTextColor =
        isDark ? AppColors.secondaryTextDarkColor : AppColors.secondaryTextLightColor;
    final lang = context.locale.languageCode;
    final genre = GenreHelper.getGenreNames(
      widget.movie.genreIds,
      languageCode: lang,
      limit: 1,
    );

    return GestureDetector(
      onTap: widget.onTap,
      child: SizedBox(
        width: 128.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster with Overlays
            Container(
              height: 168.h,
              width: 128.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                color: isDark ? const Color(0xFF171B26) : const Color(0xFFE2E8F0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Poster Image
                  if (widget.movie.posterPath != null &&
                      widget.movie.posterPath!.isNotEmpty)
                    Image.network(
                      widget.movie.posterUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _placeholder(),
                    )
                  else
                    _placeholder(),

                  // Rating Badge (Top Left)
                  Positioned(
                    top: 8.h,
                    left: 8.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 6.w, vertical: 3.h),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.75),
                        borderRadius: BorderRadius.circular(9999.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: const Color(0xFFFFC107),
                            size: 13.sp,
                          ),
                          SizedBox(width: 3.w),
                          Text(
                            widget.movie.ratingFormatted,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.5.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Bookmark Button (Bottom Right)
                  Positioned(
                    bottom: 8.h,
                    right: 8.w,
                    child: GestureDetector(
                      onTap: _toggleBookmark,
                      child: Container(
                        width: 28.r,
                        height: 28.r,
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Icon(
                          _isBookmarked
                              ? Icons.bookmark_rounded
                              : Icons.bookmark_border_rounded,
                          size: 16.sp,
                          color: _isBookmarked
                              ? AppColors.primaryColor
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 8.h),

            // Title
            Text(
              widget.movie.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: textColor,
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 2.h),

            // Genre • Year
            Text(
              [
                if (genre.isNotEmpty) genre,
                if (widget.movie.releaseYear.isNotEmpty) widget.movie.releaseYear,
              ].join(' • '),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: secondaryTextColor,
                fontSize: 11.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: const Color(0xFF1E2330),
      child: Center(
        child: Icon(
          Icons.movie_outlined,
          color: AppColors.primaryColor.withValues(alpha: 0.6),
          size: 32.sp,
        ),
      ),
    );
  }
}
