import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/routes/app_routes.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/top_rated_card.dart';
import 'package:movie_discovery_app/features/search/domain/entities/search_item.dart';
import 'package:movie_discovery_app/features/search/presentation/view_models/search_state.dart';
import 'package:movie_discovery_app/features/search/presentation/widgets/person_result_card.dart';

class SearchResultsView extends StatelessWidget {
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
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final primaryColor = isDark
        ? AppColors.primaryTextDarkColor
        : AppColors.primaryColor;

    final bgColor = isDark ? AppColors.bgDarkColor : AppColors.bgLightColor;

    final fieldColor = isDark
        ? AppColors.fieldDarkColor
        : AppColors.fieldLightColor;

    final textColor = isDark
        ? AppColors.textDarkColor
        : AppColors.textLightColor;

    return Column(
      children: [
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 0, 16.w, 10.h),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.5.h),
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
                      text: isArabic
                          ? 'عدد النتائج ${results.length} عن '
                          : '${results.length} results found for ',
                    ),
                    TextSpan(
                      text: '"${state.query}"',
                      style: TextStyle(color: primaryColor),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        if (state.isLoading)
          LinearProgressIndicator(
            minHeight: 2,
            color: primaryColor,
            backgroundColor: bgColor,
          ),

        Expanded(
          child: ListView.builder(
            itemCount: results.length,
            itemBuilder: (context, index) {
              final item = results[index];

              if (item.type == SearchItemType.person) {
                return PersonResultCard(
                  item: item,
                  onTap: () => onPersonTap?.call(item),
                );
              }

              return TopRatedCard(
                movie: item.toMovie(),
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.movieDetailsRouteName,
                    arguments: item.id,
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}
