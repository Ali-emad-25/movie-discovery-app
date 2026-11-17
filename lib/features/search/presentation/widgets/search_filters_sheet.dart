import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/search/presentation/view_models/search_cubit.dart';
import 'package:movie_discovery_app/features/search/presentation/view_models/search_state.dart';

class SearchFiltersSheet extends StatelessWidget {
  final bool isArabic;

  const SearchFiltersSheet({super.key, required this.isArabic});

  String _t(String en, String ar) => isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * .86;
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        final theme = Theme.of(context);
        final isDark = theme.brightness == Brightness.dark;
        final surfaceColor = isDark
            ? AppColors.cardDarkColor
            : AppColors.cardLightColor;
        final primaryColor = AppColors.primaryColor;
        final textColor = isDark
            ? AppColors.textDarkColor
            : AppColors.textLightColor;
        final secondaryTextColor = isDark
            ? AppColors.secondaryTextDarkColor
            : AppColors.secondaryTextLightColor;
        final hintColor = isDark
            ? AppColors.hintDarkColor
            : AppColors.hintLightColor;
        final borderColor = isDark
            ? AppColors.dividerDarkColor
            : AppColors.dividerLightColor;
        final selectedTextColor = AppColors.textDarkColor;
        final cubit = context.read<SearchCubit>();
        final genres = <int, String>{
          878: 'Sci-Fi',
          28: 'Action',
          18: 'Drama',
          53: 'Thriller',
          12: 'Adventure',
          27: 'Horror',
          35: 'Comedy',
          16: 'Animation',
          9648: 'Mystery',
          99: 'Documentary',
        };
        return SizedBox(
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: surfaceColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
            ),
            child: Column(
              children: [
                SizedBox(
                  height: 30.h,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.only(top: 10.h),
                      width: 38.w,
                      height: 3.h,
                      decoration: BoxDecoration(
                        color: hintColor,
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsetsDirectional.fromSTEB(24.w, 5.h, 16.w, 2.h),
                  child: Row(
                    children: [
                      Container(
                        width: 30.r,
                        height: 30.r,
                        decoration: BoxDecoration(
                          color: primaryColor.withValues(alpha: .16),
                          borderRadius: BorderRadius.circular(7.r),
                        ),
                        child: Icon(
                          Icons.tune_rounded,
                          color: primaryColor,
                          size: 14.sp,
                        ),
                      ),
                      SizedBox(width: 7.w),
                      Expanded(
                        child: Text(
                          _t('Filters & Sort', 'التصفية والترتيب'),
                          style: TextStyle(
                            color: textColor,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: cubit.resetFilters,
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 5.w),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(
                          _t('Reset All', 'إعادة ضبط'),
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 10.sp,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        padding: EdgeInsets.zero,
                        constraints: BoxConstraints.tightFor(
                          width: 30.w,
                          height: 30.h,
                        ),
                        visualDensity: VisualDensity.compact,
                        icon: Container(
                          width: 30.r,
                          height: 30.r,
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.borderDarkColor
                                : AppColors.borderLightColor,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.close_rounded,
                            color: secondaryTextColor,
                            size: 15.sp,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      21.w,
                      28.h,
                      21.w,
                      8.h,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _label(context, _t('CONTENT TYPE', 'نوع المحتوى')),
                        SizedBox(height: 6.h),
                        _ContentTypeSelector(
                          selectedType: state.contentType,
                          isArabic: isArabic,
                          onChanged: cubit.setContentType,
                        ),
                        SizedBox(height: 13.h),
                        _label(context, _t('SORT BY', 'ترتيب حسب')),
                        SizedBox(height: 6.h),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _sortChip(
                                context,
                                _t('Popularity', 'الشعبية'),
                                state.sortBy == SearchSortBy.popularity,
                                () => cubit.setSortBy(SearchSortBy.popularity),
                              ),
                              SizedBox(width: 6.w),
                              _sortChip(
                                context,
                                _t('Rating (High to Low)', 'التقييم'),
                                state.sortBy == SearchSortBy.rating,
                                () => cubit.setSortBy(SearchSortBy.rating),
                              ),
                              SizedBox(width: 6.w),
                              _sortChip(
                                context,
                                _t('Release Date', 'تاريخ الإصدار'),
                                state.sortBy == SearchSortBy.releaseDate,
                                () => cubit.setSortBy(SearchSortBy.releaseDate),
                              ),
                              SizedBox(width: 6.w),
                              _sortChip(
                                context,
                                _t('Title (A-Z)', 'العنوان (أ-ي)'),
                                state.sortBy == SearchSortBy.titleAZ,
                                () => cubit.setSortBy(SearchSortBy.titleAZ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Container(
                          padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 14.h),
                          decoration: BoxDecoration(
                            color: isDark
                                ? AppColors.dividerDarkColor
                                : AppColors.dividerLightColor,
                            border: Border.all(
                              color: isDark
                                  ? AppColors.borderDarkColor
                                  : AppColors.borderLightColor,
                            ),
                            borderRadius: BorderRadius.circular(22.r),
                          ),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _label(
                                      context,
                                      _t('TMDB SCORE RANGE', 'نطاق التقييم'),
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 6.w,
                                      vertical: 3.h,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppColors.cardDarkColor
                                          : AppColors.cardLightColor,
                                      borderRadius: BorderRadius.circular(10.r),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.star_rounded,
                                          color: _scoreOrange,
                                          size: 12.sp,
                                        ),
                                        SizedBox(width: 2.w),
                                        Text(
                                          '${state.minimumScore.toStringAsFixed(1)} – ${state.maximumScore.toStringAsFixed(1)}',
                                          style: TextStyle(
                                            color: _scoreOrange,
                                            fontSize: 10.sp,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              SliderTheme(
                                data: SliderTheme.of(context).copyWith(
                                  trackHeight: 6.h,
                                  rangeTrackShape: _ScoreRangeTrackShape(
                                    gradient: LinearGradient(
                                      colors: [primaryColor, _scoreOrange],
                                    ),
                                  ),
                                  rangeThumbShape: _ScoreRangeThumbShape(
                                    startColor: primaryColor,
                                    endColor: _scoreOrange,
                                    ringColor: isDark
                                        ? AppColors.borderDarkColor
                                        : AppColors.cardLightColor,
                                    radius: 13.r,
                                  ),
                                  overlayShape: RoundSliderOverlayShape(
                                    overlayRadius: 14.r,
                                  ),
                                ),
                                child: RangeSlider(
                                  values: RangeValues(
                                    state.minimumScore,
                                    state.maximumScore,
                                  ),
                                  min: 0,
                                  max: 10,
                                  activeColor: primaryColor,
                                  inactiveColor: borderColor,
                                  onChanged: (value) => cubit.setScoreRange(
                                    value.start,
                                    value.end,
                                  ),
                                ),
                              ),
                              SizedBox(height: 8.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  _rangeText(context, _t('Any', 'الكل')),
                                  _rangeText(context, '5.0+'),
                                  _rangeText(
                                    context,
                                    '7.5+',
                                    color: primaryColor,
                                  ),
                                  _rangeText(context, '8.5+'),
                                  _rangeText(context, '9.5+'),
                                ],
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _label(
                          context,
                          _t(
                            'GENRES (CHOOSE MULTIPLE)',
                            'الأنواع (اختر أكثر من نوع)',
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Wrap(
                          spacing: 9.w,
                          runSpacing: 7.h,
                          children: genres.entries
                              .map(
                                (entry) => _sortChip(
                                  context,
                                  _genreLabel(entry.value),
                                  state.selectedGenres.contains(entry.key),
                                  () => cubit.toggleGenre(entry.key),
                                ),
                              )
                              .toList(),
                        ),
                        SizedBox(height: 12.h),
                        _label(context, _t('RELEASE ERA', 'فترة الإصدار')),
                        SizedBox(height: 6.h),
                        Wrap(
                          spacing: 6.w,
                          runSpacing: 5.h,
                          children: [
                            _sortChip(
                              context,
                              _t('All Time', 'كل الفترات'),
                              state.startYear == null,
                              () => cubit.setReleaseEra(null),
                            ),
                            _sortChip(
                              context,
                              '2024 – Present',
                              state.startYear == 2024 && state.endYear == null,
                              () => cubit.setReleaseEra(2024),
                            ),
                            _sortChip(
                              context,
                              '2020s',
                              state.startYear == 2020 && state.endYear == 2029,
                              () => cubit.setReleaseEra(2020, 2029),
                            ),
                            _sortChip(
                              context,
                              '2010s',
                              state.startYear == 2010 && state.endYear == 2019,
                              () => cubit.setReleaseEra(2010, 2019),
                            ),
                            _sortChip(
                              context,
                              '2000s',
                              state.startYear == 2000 && state.endYear == 2009,
                              () => cubit.setReleaseEra(2000, 2009),
                            ),
                            _sortChip(
                              context,
                              '90s Classics',
                              state.startYear == 1990 && state.endYear == 1999,
                              () => cubit.setReleaseEra(1990, 1999),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: borderColor)),
                  ),
                  padding: EdgeInsetsDirectional.fromSTEB(
                    21.w,
                    18.h,
                    21.w,
                    18.h,
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    height: 46.h,
                    child: Material(
                      color: AppColors.transparent,
                      borderRadius: BorderRadius.circular(24.r),
                      child: InkWell(
                        onTap: () => Navigator.pop(context),
                        borderRadius: BorderRadius.circular(24.r),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                primaryColor,
                                Color.lerp(
                                  primaryColor,
                                  AppColors.primaryTextDarkColor,
                                  .14,
                                )!,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(24.r),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _t('Apply Filters', 'تطبيق الفلاتر'),
                                style: TextStyle(
                                  color: selectedTextColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 4.h,
                                ),
                                decoration: BoxDecoration(
                                  color: selectedTextColor.withValues(
                                    alpha: .24,
                                  ),
                                  borderRadius: BorderRadius.circular(24.r),
                                ),
                                child: Text(
                                  isArabic
                                      ? '${state.visibleResults.length} نتيجة'
                                      : '${state.visibleResults.length} Results',
                                  style: TextStyle(
                                    color: selectedTextColor,
                                    fontSize: 12.sp,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              SizedBox(width: 12.w),
                              Icon(
                                Icons.arrow_forward_rounded,
                                color: selectedTextColor,
                                size: 20.sp,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _label(BuildContext context, String value) => Text(
    value,
    style: TextStyle(
      color: Theme.of(context).brightness == Brightness.dark
          ? AppColors.secondaryTextDarkColor
          : AppColors.secondaryTextLightColor,
      fontSize: 9.sp,
      fontWeight: FontWeight.w800,
      letterSpacing: .5,
    ),
  );

  Widget _rangeText(BuildContext context, String value, {Color? color}) => Text(
    value,
    style: TextStyle(
      color:
          color ??
          (Theme.of(context).brightness == Brightness.dark
              ? AppColors.secondaryTextDarkColor
              : AppColors.secondaryTextLightColor),
      fontSize: 9.sp,
    ),
  );

  Widget _sortChip(
    BuildContext context,
    String label,
    bool selected,
    VoidCallback onTap,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = AppColors.primaryColor;
    final chipColor = isDark
        ? AppColors.borderDarkColor
        : AppColors.borderLightColor;
    final textColor = isDark
        ? AppColors.secondaryTextDarkColor
        : AppColors.secondaryTextLightColor;

    return Material(
      color: selected ? primaryColor : chipColor,
      borderRadius: BorderRadius.circular(24.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (selected) ...[
                Icon(
                  Icons.check_rounded,
                  color: AppColors.textDarkColor,
                  size: 14.sp,
                ),
                SizedBox(width: 4.w),
              ],
              Text(
                label,
                maxLines: 1,
                style: TextStyle(
                  color: selected ? AppColors.textDarkColor : textColor,
                  fontSize: 13.sp,
                  fontWeight: selected ? FontWeight.w500 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _genreLabel(String genre) {
    if (!isArabic) return genre;
    return const {
          'Sci-Fi': 'خيال علمي',
          'Action': 'أكشن',
          'Drama': 'دراما',
          'Thriller': 'إثارة',
          'Adventure': 'مغامرة',
          'Horror': 'رعب',
          'Comedy': 'كوميديا',
          'Animation': 'رسوم متحركة',
          'Mystery': 'غموض',
          'Documentary': 'وثائقي',
        }[genre] ??
        genre;
  }
}

class _ContentTypeSelector extends StatelessWidget {
  final SearchContentType selectedType;
  final bool isArabic;
  final ValueChanged<SearchContentType> onChanged;

  const _ContentTypeSelector({
    required this.selectedType,
    required this.isArabic,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? AppColors.dividerDarkColor
        : AppColors.dividerLightColor;
    final borderColor = isDark
        ? AppColors.borderDarkColor
        : AppColors.borderLightColor;
    final primaryColor = AppColors.primaryColor;
    final textColor = isDark
        ? AppColors.secondaryTextDarkColor
        : AppColors.secondaryTextLightColor;

    final options = <(SearchContentType, String)>[
      (SearchContentType.all, isArabic ? 'الكل' : 'All'),
      (SearchContentType.movies, isArabic ? 'أفلام' : 'Movies'),
      (SearchContentType.tvShows, isArabic ? 'مسلسلات' : 'TV Shows'),
      (SearchContentType.people, isArabic ? 'أشخاص' : 'People'),
    ];

    return Container(
      height: 44.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: options.map((option) {
          final selected = selectedType == option.$1;
          return Expanded(
            child: InkWell(
              onTap: () => onChanged(option.$1),
              borderRadius: BorderRadius.circular(22.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected ? primaryColor : AppColors.transparent,
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: Text(
                  option.$2,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected ? AppColors.textDarkColor : textColor,
                    fontSize: 14.sp,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

const Color _scoreOrange = Color(0xFFFFB24A);

class _ScoreRangeTrackShape extends RoundedRectRangeSliderTrackShape {
  final LinearGradient gradient;

  const _ScoreRangeTrackShape({required this.gradient});

  @override
  void paint(
    PaintingContext context,
    Offset offset, {
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required Animation<double> enableAnimation,
    required Offset startThumbCenter,
    required Offset endThumbCenter,
    bool isEnabled = false,
    bool isDiscrete = false,
    required TextDirection textDirection,
    double additionalActiveTrackHeight = 2,
  }) {
    super.paint(
      context,
      offset,
      parentBox: parentBox,
      sliderTheme: sliderTheme,
      enableAnimation: enableAnimation,
      startThumbCenter: startThumbCenter,
      endThumbCenter: endThumbCenter,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
      textDirection: textDirection,
      additionalActiveTrackHeight: additionalActiveTrackHeight,
    );

    final leftThumb = textDirection == TextDirection.ltr
        ? startThumbCenter
        : endThumbCenter;
    final rightThumb = textDirection == TextDirection.ltr
        ? endThumbCenter
        : startThumbCenter;
    final trackRect = getPreferredRect(
      parentBox: parentBox,
      offset: offset,
      sliderTheme: sliderTheme,
      isEnabled: isEnabled,
      isDiscrete: isDiscrete,
    );
    if (rightThumb.dx <= leftThumb.dx) return;

    final gradientRect = Rect.fromLTRB(
      leftThumb.dx,
      trackRect.top - 1,
      rightThumb.dx,
      trackRect.bottom + 1,
    );
    final activeGradient = textDirection == TextDirection.ltr
        ? gradient
        : LinearGradient(
            begin: gradient.end,
            end: gradient.begin,
            colors: gradient.colors,
            stops: gradient.stops,
          );
    final trackRadius = Radius.circular(gradientRect.height / 2);
    context.canvas.drawRRect(
      RRect.fromRectAndRadius(gradientRect, trackRadius),
      Paint()..shader = activeGradient.createShader(gradientRect),
    );
  }
}

class _ScoreRangeThumbShape extends RangeSliderThumbShape {
  final Color startColor;
  final Color endColor;
  final Color ringColor;
  final double radius;

  const _ScoreRangeThumbShape({
    required this.startColor,
    required this.endColor,
    required this.ringColor,
    required this.radius,
  });

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(radius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    bool isDiscrete = false,
    bool isEnabled = false,
    bool? isOnTop,
    required SliderThemeData sliderTheme,
    TextDirection? textDirection,
    Thumb? thumb,
    bool? isPressed,
  }) {
    final canvas = context.canvas;
    final color = thumb == Thumb.end ? endColor : startColor;
    canvas.drawCircle(center, radius, Paint()..color = ringColor);
    canvas.drawCircle(center, radius * .58, Paint()..color = color);
  }
}
