import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/search/presentation/view_models/search_state.dart';

class SearchSuggestions extends StatelessWidget {
  final SearchState state;
  final bool isArabic;
  final ValueChanged<String> onSelectQuery;

  const SearchSuggestions({
    super.key,
    required this.state,
    required this.isArabic,
    required this.onSelectQuery,
  });

  String _t(String en, String ar) => isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    const popular = [
      'The Odyssey',
      'The Beast',
      'Spider-Man',
      'Dune',
      'Project Hail Mary',
    ];

    return ListView(
      padding: EdgeInsetsDirectional.fromSTEB(18.w, 10.h, 18.w, 22.h),
      children: [
        if (state.recentSearches.isNotEmpty) ...[
          _SectionLabel(label: _t('RECENT SEARCHES', 'عمليات البحث الأخيرة')),
          SizedBox(height: 17.h),
          Wrap(
            spacing: 6.w,
            runSpacing: 9.h,
            children: state.recentSearches
                .take(4)
                .map(
                  (query) => _SearchChip(
                    label: query,
                    onTap: () => onSelectQuery(query),
                  ),
                )
                .toList(),
          ),
          SizedBox(height: 22.h),
        ],
        _SectionLabel(label: _t('POPULAR SEARCHES', 'عمليات البحث الشائعة')),
        SizedBox(height: 17.h),
        Wrap(
          spacing: 6.w,
          runSpacing: 9.h,
          children: popular
              .map(
                (query) => _SearchChip(
                  label: query,
                  onTap: () => onSelectQuery(query),
                ),
              )
              .toList(),
        ),
        SizedBox(height: 108.h),
        _SearchPrompt(isArabic: isArabic),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;

  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final secondaryColor = isDark
        ? AppColors.secondaryTextDarkColor
        : AppColors.secondaryTextLightColor;
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              color: secondaryColor,
              fontSize: 10.sp,
              fontWeight: FontWeight.w800,
              letterSpacing: .6,
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchChip extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SearchChip({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fieldColor = isDark
        ? AppColors.borderDarkColor
        : AppColors.fieldLightColor;
    final textColor = isDark
        ? AppColors.textDarkColor
        : AppColors.textLightColor;
    return Material(
      color: fieldColor,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsetsDirectional.fromSTEB(10.w, 9.h, 10.w, 9.h),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                label,
                style: TextStyle(color: textColor, fontSize: 11.sp),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchPrompt extends StatelessWidget {
  final bool isArabic;

  const _SearchPrompt({required this.isArabic});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColors.primaryTextDarkColor
        : AppColors.primaryColor;
    final textColor = isDark
        ? AppColors.textDarkColor
        : AppColors.textLightColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 120.r,
          height: 120.r,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: primaryColor.withValues(alpha: .20),
            boxShadow: [
              BoxShadow(
                color: primaryColor.withValues(alpha: .26),
                blurRadius: 34,
                spreadRadius: 5,
              ),
            ],
          ),
          child: Icon(Icons.search_rounded, color: primaryColor, size: 42.sp),
        ),
        SizedBox(height: 38.h),
        Text(
          isArabic ? 'ابحث للعثور على النتائج' : 'Search To Find Results',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textColor,
            fontSize: 20.sp,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}
