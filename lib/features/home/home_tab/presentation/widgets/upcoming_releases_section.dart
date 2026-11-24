import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/core/utils/genre_helper.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/movie.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/home_section_header.dart';
import 'package:movie_discovery_app/features/notifications/presentation/view_models/notifications_cubit.dart';
import 'package:movie_discovery_app/features/notifications/presentation/view_models/notifications_state.dart';

class UpcomingReleasesSection extends StatelessWidget {
  final List<Movie> movies;
  final VoidCallback? onSeeAll;
  final void Function(Movie movie)? onMovieTap;

  const UpcomingReleasesSection({
    super.key,
    required this.movies,
    this.onSeeAll,
    this.onMovieTap,
  });

  @override
  Widget build(BuildContext context) {
    if (movies.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        HomeSectionHeader(
          title: 'home.sections.upcoming_releases'.tr(),
          accentColor: const Color(0xFFFF383C), // Red accent from Figma
          onSeeAll: onSeeAll,
        ),

        SizedBox(height: 12.h),

        // Horizontal List of Cards
        SizedBox(
          height: 146.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: movies.length,
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final movie = movies[index];
              return _UpcomingCard(
                movie: movie,
                onTap: () => onMovieTap?.call(movie),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _UpcomingCard extends StatelessWidget {
  final Movie movie;
  final VoidCallback? onTap;

  const _UpcomingCard({
    required this.movie,
    this.onTap,
  });

  Future<void> _toggleReminder(BuildContext context) async {
    final added = await context.read<NotificationsCubit>().toggleReminder(
          movieId: movie.id,
          title: movie.title,
          posterPath: movie.posterPath,
          releaseDate: movie.releaseDate,
          notificationTitle: '${movie.title} — ${'notifications.reminder_title'.tr()}',
          notificationBody: 'notifications.reminder_body'.tr(),
        );
    if (added == null) return;

    Fluttertoast.showToast(
      msg: added ? 'home.reminder_set'.tr() : 'notifications.reminder_cancelled'.tr(),
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: const Color(0xFF171B26),
      textColor: Colors.white,
    );
  }

  String _formatReleaseDate(String dateStr) {
    if (dateStr.isEmpty) return 'SOON';
    try {
      final date = DateTime.parse(dateStr);
      final months = [
        'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
        'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC',
      ];
      return '${months[date.month - 1]} ${date.year}';
    } catch (_) {
      return dateStr;
    }
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
      movie.genreIds,
      languageCode: lang,
      limit: 2,
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 290.w,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Poster
            Container(
              width: 80.w,
              height: 116.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                color: isDark ? const Color(0xFF1F2432) : const Color(0xFFE2E8F0),
              ),
              clipBehavior: Clip.antiAlias,
              child: movie.posterPath != null &&
                      movie.posterPath!.isNotEmpty
                  ? Image.network(
                      movie.posterUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _placeholder(),
                    )
                  : _placeholder(),
            ),

            SizedBox(width: 14.w),

            // Info & Remind Me button
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Month/Year Pill
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD2BBFF).withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      _formatReleaseDate(movie.releaseDate),
                      style: TextStyle(
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFD2BBFF),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),

                  // Title
                  Text(
                    movie.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),

                  // Type • Genre
                  Text(
                    [
                      movie.isTvShow
                          ? 'home.tv_show'.tr()
                          : 'home.movie'.tr(),
                      if (genre.isNotEmpty) genre,
                    ].join(' • '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11.sp,
                      color: secondaryTextColor,
                    ),
                  ),

                  // Remind Me Button (reactive to sqflite NotificationsCubit)
                  BlocBuilder<NotificationsCubit, NotificationsState>(
                    builder: (context, state) {
                      final isReminderSet = state is NotificationsLoaded &&
                          state.isReminderSet(movie.id);

                      return GestureDetector(
                        onTap: () => _toggleReminder(context),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 6.h,
                          ),
                          decoration: BoxDecoration(
                            color: isReminderSet
                                ? AppColors.primaryColor
                                : (isDark
                                    ? const Color(0xFF313540)
                                    : const Color(0xFFE2E8F0)),
                            borderRadius: BorderRadius.circular(9999.r),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isReminderSet
                                    ? Icons.notifications_active_rounded
                                    : Icons.notifications_none_rounded,
                                size: 13.sp,
                                color: isReminderSet
                                    ? Colors.white
                                    : (isDark ? Colors.white : AppColors.textLightColor),
                              ),
                              SizedBox(width: 4.w),
                              Text(
                                'home.remind_me'.tr(),
                                style: TextStyle(
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                  color: isReminderSet
                                      ? Colors.white
                                      : (isDark ? Colors.white : AppColors.textLightColor),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
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
        size: 28.sp,
      ),
    );
  }
}
