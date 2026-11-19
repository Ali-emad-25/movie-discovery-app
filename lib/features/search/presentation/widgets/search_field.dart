import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/search/presentation/view_models/search_cubit.dart';
import 'package:movie_discovery_app/features/search/presentation/view_models/search_state.dart';

class SearchField extends StatelessWidget {
  final TextEditingController controller;
  final bool isArabic;
  final VoidCallback onOpenFilters;
  final VoidCallback onClear;

  const SearchField({
    super.key,
    required this.controller,
    required this.isArabic,
    required this.onOpenFilters,
    required this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textDarkColor
        : AppColors.textLightColor;
    final primaryColor = isDark
        ? AppColors.primaryTextDarkColor
        : AppColors.primaryColor;
    final fieldColor = isDark
        ? AppColors.borderDarkColor
        : AppColors.fieldLightColor;
    final hintColor = isDark
        ? AppColors.hintDarkColor
        : AppColors.hintLightColor;
    final secondaryColor = isDark
        ? AppColors.secondaryTextDarkColor
        : AppColors.secondaryTextLightColor;

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(20.w, 10.h, 20.w, 10.h),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 40.h,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: fieldColor,
                borderRadius: BorderRadius.circular(30.r),
              ),
              child: TextField(
                controller: controller,
                style: TextStyle(color: textColor, fontSize: 13.sp),
                cursorColor: primaryColor,
                textInputAction: TextInputAction.search,
                onChanged: context.read<SearchCubit>().updateQuery,
                onSubmitted: context.read<SearchCubit>().search,
                decoration: InputDecoration(
                  filled: false,
                  hintText: isArabic ? 'بحث' : 'Search',
                  hintStyle: TextStyle(color: hintColor, fontSize: 15.sp),
                  prefixIcon: Icon(
                    Icons.search_rounded,
                    color: secondaryColor,
                    size: 20.sp,
                  ),
                  prefixIconConstraints: BoxConstraints(minWidth: 35.w),
                  suffixIconConstraints: BoxConstraints(minWidth: 34.w),
                  suffixIcon: BlocBuilder<SearchCubit, SearchState>(
                    buildWhen: (previous, current) =>
                        previous.query != current.query,
                    builder: (context, state) => state.hasQuery
                        ? IconButton(
                            padding: EdgeInsets.zero,
                            onPressed: onClear,
                            icon: Icon(
                              Icons.close_rounded,
                              color: secondaryColor,
                              size: 15.sp,
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 8.h),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30.r),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 6.w),
          Material(
            color: fieldColor,
            borderRadius: BorderRadius.circular(25.r),
            child: InkWell(
              onTap: onOpenFilters,
              borderRadius: BorderRadius.circular(25.r),
              child: SizedBox(
                height: 43.h,
                width: 43.w,
                child: Icon(Icons.tune_rounded, color: textColor, size: 18.sp),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
