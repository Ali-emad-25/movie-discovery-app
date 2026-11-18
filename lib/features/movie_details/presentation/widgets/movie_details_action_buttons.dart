import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';

class MovieDetailsActionButtons extends StatefulWidget {
  final bool initialIsWatchlist;
  final ValueChanged<bool>? onWatchlistChanged;

  const MovieDetailsActionButtons({
    super.key,
    this.initialIsWatchlist = false,
    this.onWatchlistChanged,
  });

  @override
  State<MovieDetailsActionButtons> createState() =>
      _MovieDetailsActionButtonsState();
}

class _MovieDetailsActionButtonsState extends State<MovieDetailsActionButtons> {
  late bool _isWatchlist;
  bool _isWatched = false;
  bool _isRated = false;

  @override
  void initState() {
    super.initState();
    _isWatchlist = widget.initialIsWatchlist;
  }

  void _toggleWatchlist() {
    setState(() {
      _isWatchlist = !_isWatchlist;
    });
    widget.onWatchlistChanged?.call(_isWatchlist);
    Fluttertoast.showToast(
      msg: _isWatchlist
          ? 'movie_details.added_to_watchlist'.tr()
          : 'movie_details.removed_from_watchlist'.tr(),
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: const Color(0xFF171B26),
      textColor: Colors.white,
    );
  }

  void _toggleWatched() {
    setState(() {
      _isWatched = !_isWatched;
    });
    Fluttertoast.showToast(
      msg: _isWatched
          ? 'movie_details.marked_watched'.tr()
          : 'movie_details.unmarked_watched'.tr(),
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: const Color(0xFF171B26),
      textColor: Colors.white,
    );
  }

  void _rateMovie() {
    setState(() {
      _isRated = !_isRated;
    });
    Fluttertoast.showToast(
      msg: _isRated
          ? (context.locale.languageCode == 'ar'
              ? 'شكراً لتقييمك!'
              : 'Thanks for rating!')
          : (context.locale.languageCode == 'ar'
              ? 'تم إلغاء التقييم'
              : 'Rating removed'),
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: const Color(0xFF171B26),
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final buttonBg = isDark ? const Color(0xFF171B26) : Colors.white;
    final borderColor =
        isDark ? const Color(0xFF2A2F42) : const Color(0xFFCBD5E1);
    final textColor = isDark ? Colors.white : AppColors.textLightColor;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          // Watchlist CTA Button (Flex 3)
          Expanded(
            flex: 3,
            child: GestureDetector(
              onTap: _toggleWatchlist,
              child: Container(
                height: 46.h,
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  borderRadius: BorderRadius.circular(9999.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryColor.withValues(alpha: 0.35),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isWatchlist ? Icons.check_rounded : Icons.add_rounded,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        _isWatchlist
                            ? 'movie_details.in_watchlist'.tr()
                            : 'movie_details.add_to_watchlist'.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(width: 8.w),

          // Watched Button (Flex 2)
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: _toggleWatched,
              child: Container(
                height: 46.h,
                padding: EdgeInsets.symmetric(horizontal: 8.w),
                decoration: BoxDecoration(
                  color: _isWatched
                      ? (isDark
                          ? const Color(0xFF1E2230)
                          : const Color(0xFFE2E8F0))
                      : buttonBg,
                  borderRadius: BorderRadius.circular(9999.r),
                  border: Border.all(
                    color: _isWatched ? AppColors.primaryColor : borderColor,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.check_rounded,
                      color: _isWatched ? AppColors.primaryColor : textColor,
                      size: 16.sp,
                    ),
                    SizedBox(width: 4.w),
                    Flexible(
                      child: Text(
                        'movie_details.watched'.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12.5.sp,
                          fontWeight: FontWeight.w600,
                          color:
                              _isWatched ? AppColors.primaryColor : textColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(width: 8.w),

          // Rate Button
          GestureDetector(
            onTap: _rateMovie,
            child: Container(
              width: 46.r,
              height: 46.r,
              decoration: BoxDecoration(
                color: buttonBg,
                shape: BoxShape.circle,
                border: Border.all(
                  color: _isRated ? const Color(0xFFFFC107) : borderColor,
                ),
              ),
              child: Icon(
                _isRated ? Icons.star_rounded : Icons.star_outline_rounded,
                color: _isRated ? const Color(0xFFFFC107) : textColor,
                size: 20.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
