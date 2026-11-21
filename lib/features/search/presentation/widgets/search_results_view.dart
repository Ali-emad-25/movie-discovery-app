import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/core/utils/genre_helper.dart';
import 'package:movie_discovery_app/features/search/domain/entities/search_item.dart';
import 'package:movie_discovery_app/features/search/presentation/view_models/search_state.dart';

class SearchResultsView extends StatefulWidget {
  final SearchState state;
  final List<SearchItem> results;
  final bool isArabic;
  final ValueChanged<SearchItem>? onPersonTap;

  const SearchResultsView({
    super.key,
    required this.state,
    required this.results,
    required this.isArabic,
    this.onPersonTap,
  });

  @override
  State<SearchResultsView> createState() => _SearchResultsViewState();
}

class _SearchResultsViewState extends State<SearchResultsView> {
  final Set<int> _favorites = {};
  bool _gridMode = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? AppColors.bgDarkColor : AppColors.bgLightColor;
    final fieldColor = isDark
        ? AppColors.fieldDarkColor
        : AppColors.fieldLightColor;
    final textColor = isDark
        ? AppColors.textDarkColor
        : AppColors.textLightColor;
    final primaryColor = isDark
        ? AppColors.primaryTextDarkColor
        : AppColors.primaryColor;
    final secondaryColor = isDark
        ? AppColors.secondaryTextDarkColor
        : AppColors.secondaryTextLightColor;
    return Column(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(17.w, 0, 14.w, 0),
          child: Row(
            children: [
              Expanded(
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 4.5.h,
                    ),
                    decoration: BoxDecoration(
                      color: fieldColor,
                      borderRadius: BorderRadius.circular(15.r),
                    ),
                    child: RichText(
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      text: TextSpan(
                        style: TextStyle(color: textColor, fontSize: 13.sp),
                        children: [
                          TextSpan(
                            text: widget.isArabic
                                ? 'عدد النتائج ${widget.results.length} عن '
                                : '${widget.results.length} results found for ',
                          ),
                          TextSpan(
                            text: '"${widget.state.query}"',
                            style: TextStyle(color: primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                height: 32.h,
                padding: EdgeInsets.all(2.r),
                decoration: BoxDecoration(
                  color: isDark
                      ? AppColors.dividerDarkColor
                      : AppColors.dividerLightColor,
                  border: Border.all(
                    color: isDark
                        ? AppColors.borderDarkColor
                        : AppColors.borderLightColor,
                    width: 1.r,
                  ),
                  borderRadius: BorderRadius.circular(18.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _ViewModeButton(
                      selected: !_gridMode,
                      icon: Icons.view_list_rounded,
                      iconSize: 17.sp,
                      selectedColor: isDark
                          ? AppColors.borderDarkColor
                          : AppColors.cardLightColor,
                      selectedIconColor: primaryColor,
                      unselectedIconColor: secondaryColor,
                      onTap: () => setState(() => _gridMode = false),
                    ),
                    _ViewModeButton(
                      selected: _gridMode,
                      icon: Icons.grid_view_rounded,
                      iconSize: 15.sp,
                      selectedColor: isDark
                          ? AppColors.borderDarkColor
                          : AppColors.cardLightColor,
                      selectedIconColor: primaryColor,
                      unselectedIconColor: secondaryColor,
                      onTap: () => setState(() => _gridMode = true),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (widget.state.isLoading)
          LinearProgressIndicator(
            minHeight: 2,
            color: primaryColor,
            backgroundColor: bgColor,
          ),
        Expanded(
          child: _gridMode
              ? GridView.builder(
                  padding: EdgeInsets.fromLTRB(14.w, 6.h, 14.w, 18.h),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 9.h,
                    crossAxisSpacing: 9.w,
                    childAspectRatio: .72,
                  ),
                  itemCount: widget.results.length,
                  itemBuilder: (context, index) => _GridResultCard(
                    item: widget.results[index],
                    isFavorite: _favorites.contains(widget.results[index].id),
                    onToggleFavorite: () =>
                        _toggleFavorite(widget.results[index].id),
                    onTap: widget.results[index].type == SearchItemType.person
                        ? () => widget.onPersonTap?.call(widget.results[index])
                        : null,
                  ),
                )
              : ListView.separated(
                  padding: EdgeInsets.fromLTRB(14.w, 6.h, 14.w, 18.h),
                  itemCount: widget.results.length,
                  separatorBuilder: (_, _) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) => _SearchResultCard(
                    item: widget.results[index],
                    isArabic: widget.isArabic,
                    isFavorite: _favorites.contains(widget.results[index].id),
                    onToggleFavorite: () =>
                        _toggleFavorite(widget.results[index].id),
                    onTap: widget.results[index].type == SearchItemType.person
                        ? () => widget.onPersonTap?.call(widget.results[index])
                        : null,
                  ),
                ),
        ),
      ],
    );
  }

  void _toggleFavorite(int id) {
    setState(() {
      if (!_favorites.add(id)) _favorites.remove(id);
    });
  }
}

class _ViewModeButton extends StatelessWidget {
  final bool selected;
  final IconData icon;
  final double iconSize;
  final Color selectedColor;
  final Color selectedIconColor;
  final Color unselectedIconColor;
  final VoidCallback onTap;

  const _ViewModeButton({
    required this.selected,
    required this.icon,
    required this.iconSize,
    required this.selectedColor,
    required this.selectedIconColor,
    required this.unselectedIconColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => Material(
    color: selected ? selectedColor : AppColors.transparent,
    borderRadius: BorderRadius.circular(14.r),
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14.r),
      child: SizedBox(
        width: 28.w,
        height: 28.h,
        child: Icon(
          icon,
          color: selected ? selectedIconColor : unselectedIconColor,
          size: iconSize,
        ),
      ),
    ),
  );
}

class _SearchResultCard extends StatelessWidget {
  final SearchItem item;
  final bool isArabic;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onTap;

  const _SearchResultCard({
    required this.item,
    required this.isArabic,
    required this.isFavorite,
    required this.onToggleFavorite,
    this.onTap,
  });

  String _t(String en, String ar) => isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark
        ? AppColors.cardDarkColor
        : AppColors.cardLightColor;
    final textColor = isDark
        ? AppColors.textDarkColor
        : AppColors.textLightColor;
    final primaryColor = isDark
        ? AppColors.primaryTextDarkColor
        : AppColors.primaryColor;
    final secondaryColor = isDark
        ? AppColors.secondaryTextDarkColor
        : AppColors.secondaryTextLightColor;
    final borderColor = isDark
        ? AppColors.borderDarkColor
        : AppColors.borderLightColor;
    final item = this.item;
    final type = switch (item.type) {
      SearchItemType.movie => _t('Movie', 'فيلم'),
      SearchItemType.tv => _t('TV Show', 'مسلسل'),
      SearchItemType.person => _t('Person', 'شخص'),
    };
    final categories = item.type == SearchItemType.person
        ? item.description
        : GenreHelper.getGenreNames(
            item.genreIds,
            languageCode: isArabic ? 'ar' : 'en',
            limit: 2,
          );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 130.h,
        padding: EdgeInsets.all(12.r),
        decoration: BoxDecoration(
          color: surfaceColor,
          border: Border.all(color: borderColor, width: 1.r),
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          children: [
            _Poster(item: item, width: 64.w, height: 100.h),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    [
                      if (item.year != null) item.year.toString(),
                      if (categories.isNotEmpty) categories,
                    ].join('  •  '),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: secondaryColor, fontSize: 10.sp),
                  ),
                  if (item.type != SearchItemType.person) ...[
                    SizedBox(height: 3.h),
                    Row(
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 12.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          item.rating.toStringAsFixed(1),
                          style: TextStyle(
                            color: textColor,
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 3.h),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 6.w,
                        vertical: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor.withValues(alpha: .16),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Text(
                        type,
                        style: TextStyle(color: primaryColor, fontSize: 9.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: onToggleFavorite,
                  child: Icon(
                    isFavorite
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    color: isFavorite
                        ? (isDark
                              ? AppColors.errorDarkColor
                              : AppColors.errorLightColor)
                        : secondaryColor,
                    size: 18.sp,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _GridResultCard extends StatelessWidget {
  final SearchItem item;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;
  final VoidCallback? onTap;

  const _GridResultCard({
    required this.item,
    required this.isFavorite,
    required this.onToggleFavorite,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surfaceColor = isDark
        ? AppColors.cardDarkColor
        : AppColors.cardLightColor;
    final textColor = isDark
        ? AppColors.textDarkColor
        : AppColors.textLightColor;
    final secondaryColor = isDark
        ? AppColors.secondaryTextDarkColor
        : AppColors.secondaryTextLightColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: surfaceColor,
          borderRadius: BorderRadius.circular(14.r),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: SizedBox(
                width: double.infinity,
                child: _Poster(
                  item: item,
                  width: double.infinity,
                  height: double.infinity,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8.r),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      item.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onToggleFavorite,
                    child: Icon(
                      isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: isFavorite
                          ? (isDark
                                ? AppColors.errorDarkColor
                                : AppColors.errorLightColor)
                          : secondaryColor,
                      size: 15.sp,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsDirectional.only(
                start: 8.w,
                end: 8.w,
                bottom: 8.h,
              ),
              child: Row(
                children: [
                  Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                  SizedBox(width: 3.w),
                  Text(
                    item.rating.toStringAsFixed(1),
                    style: TextStyle(color: textColor, fontSize: 10.5.sp),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Poster extends StatelessWidget {
  final SearchItem item;
  final double width;
  final double height;

  const _Poster({
    required this.item,
    required this.width,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fieldColor = isDark
        ? AppColors.fieldDarkColor
        : AppColors.fieldLightColor;
    final secondaryColor = isDark
        ? AppColors.secondaryTextDarkColor
        : AppColors.secondaryTextLightColor;
    if (item.imageUrl.isEmpty) {
      return Container(
        width: width,
        height: height,
        color: fieldColor,
        child: Icon(
          item.type == SearchItemType.person
              ? Icons.person_outline
              : Icons.movie_outlined,
          color: secondaryColor,
          size: 22.sp,
        ),
      );
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(9.r),
      child: Image.network(
        item.imageUrl,
        width: width,
        height: height,
        fit: BoxFit.cover,
        errorBuilder: (_, _, _) => Container(
          width: width,
          height: height,
          color: fieldColor,
          child: Icon(Icons.movie_outlined, color: secondaryColor),
        ),
      ),
    );
  }
}
