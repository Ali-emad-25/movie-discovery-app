import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/core/utils/genre_helper.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/movie.dart';

class TopRatedCard extends StatefulWidget {
  final Movie movie;
  final VoidCallback? onTap;

  const TopRatedCard({
    super.key,
    required this.movie,
    this.onTap,
  });

  @override
  State<TopRatedCard> createState() => _TopRatedCardState();
}

class _TopRatedCardState extends State<TopRatedCard> {
  bool _isFavorite = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
    Fluttertoast.showToast(
      msg: _isFavorite
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
    final cardColor = isDark ? const Color(0xFF171B26) : Colors.white;
    final borderColor = isDark ? const Color(0xFF262A35) : const Color(0xFFE2E8F0);
    final textColor = isDark ? AppColors.textDarkColor : AppColors.textLightColor;
    final secondaryTextColor =
        isDark ? AppColors.secondaryTextDarkColor : AppColors.secondaryTextLightColor;
    final lang = context.locale.languageCode;
    final genre = GenreHelper.getGenreNames(
      widget.movie.genreIds,
      languageCode: lang,
      limit: 2,
    );

    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Poster
            Container(
              width: 70.w,
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.r),
                color: isDark ? const Color(0xFF1F2432) : const Color(0xFFE2E8F0),
              ),
              clipBehavior: Clip.antiAlias,
              child: widget.movie.posterPath != null &&
                      widget.movie.posterPath!.isNotEmpty
                  ? Image.network(
                      widget.movie.posterUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _placeholder(),
                    )
                  : _placeholder(),
            ),

            SizedBox(width: 14.w),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Title + More options
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          widget.movie.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                      ),
                      Icon(
                        Icons.more_vert_rounded,
                        size: 18.sp,
                        color: secondaryTextColor,
                      ),
                    ],
                  ),

                  SizedBox(height: 4.h),

                  // Type • Year • Genre
                  Text(
                    [
                      widget.movie.isTvShow
                          ? 'home.tv_show'.tr()
                          : 'home.movie'.tr(),
                      if (widget.movie.releaseYear.isNotEmpty)
                        widget.movie.releaseYear,
                      if (genre.isNotEmpty) genre,
                    ].join(' • '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.5.sp,
                      color: secondaryTextColor,
                    ),
                  ),

                  SizedBox(height: 6.h),

                  // Rating
                  Row(
                    children: [
                      Icon(
                        Icons.star_rounded,
                        color: const Color(0xFFFFC107),
                        size: 14.sp,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        widget.movie.ratingFormatted,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w700,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 8.h),

                  // Badge + Heart
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: isDark
                              ? const Color(0xFF262A35)
                              : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(9999.r),
                        ),
                        child: Text(
                          widget.movie.isTvShow
                              ? 'home.tv_show'.tr()
                              : 'home.movie'.tr(),
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            color: isDark
                                ? const Color(0xFFCCC3D8)
                                : const Color(0xFF475569),
                          ),
                        ),
                      ),

                      GestureDetector(
                        onTap: _toggleFavorite,
                        child: Container(
                          width: 32.r,
                          height: 32.r,
                          decoration: BoxDecoration(
                            color: isDark
                                ? const Color(0xFF262A35)
                                : const Color(0xFFF1F5F9),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 16.sp,
                            color: _isFavorite
                                ? const Color(0xFFFF383C)
                                : secondaryTextColor,
                          ),
                        ),
                      ),
                    ],
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
    return Center(
      child: Icon(
        Icons.movie_outlined,
        color: AppColors.primaryColor.withValues(alpha: 0.5),
        size: 24.sp,
      ),
    );
  }
}

