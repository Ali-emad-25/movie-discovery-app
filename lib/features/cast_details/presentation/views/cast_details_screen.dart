import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/di/injection.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/core/widgets/app_custom_app_bar.dart';
import 'package:movie_discovery_app/features/cast_details/domain/entities/cast_details.dart';
import 'package:movie_discovery_app/features/cast_details/presentation/view_models/cast_details_cubit.dart';
import 'package:movie_discovery_app/features/cast_details/presentation/view_models/cast_details_state.dart';

class CastDetailsScreen extends StatelessWidget {
  final int personId;

  const CastDetailsScreen({super.key, required this.personId});

  @override
  Widget build(BuildContext context) {
    final isArabic = Localizations.localeOf(context).languageCode == 'ar';
    return BlocProvider(
      create: (_) => getIt<CastDetailsCubit>(
        param1: personId,
        param2: isArabic ? 'ar-EG' : 'en-US',
      ),
      child: _CastDetailsBody(isArabic: isArabic, personId: personId),
    );
  }
}

class _CastDetailsBody extends StatefulWidget {
  final bool isArabic;
  final int personId;

  const _CastDetailsBody({required this.isArabic, required this.personId});

  @override
  State<_CastDetailsBody> createState() => _CastDetailsBodyState();
}

class _CastDetailsBodyState extends State<_CastDetailsBody> {
  int _selectedTab = 0;
  bool _showFullBiography = false;
  bool _showAllKnownFor = false;

  String _t(String en, String ar) => widget.isArabic ? ar : en;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF0F131D) : const Color(0xFFF8FAFC);
    final textColor = isDark
        ? AppColors.textDarkColor
        : AppColors.textLightColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppCustomAppBar(
        title: _t('Cast Details', 'تفاصيل الممثل'),
        icon: Icons.person,
        bgColor: bgColor,
        textColor: textColor,
      ),
      body: BlocBuilder<CastDetailsCubit, CastDetailsState>(
        builder: (context, state) {
          if (state.isLoading && state.details == null) {
            return Center(
              child: CircularProgressIndicator(color: AppColors.primaryColor),
            );
          }
          if (state.errorMessage != null && state.details == null) {
            return _errorState(context, state.errorMessage!, isDark);
          }
          final details = state.details;
          if (details == null) return const SizedBox.shrink();
          return Column(
            children: [
              _profile(details, isDark, AppColors.textDarkColor),
              _tabs(isDark),
              Expanded(
                child: RefreshIndicator(
                  color: AppColors.primaryColor,
                  onRefresh: context.read<CastDetailsCubit>().loadDetails,
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: EdgeInsetsDirectional.fromSTEB(
                      18.w,
                      17.h,
                      18.w,
                      24.h,
                    ),
                    child: _tabContent(
                      details,
                      isDark,
                      AppColors.textDarkColor,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _profile(CastDetails details, bool isDark, Color textColor) {
    final secondaryColor = isDark
        ? AppColors.secondaryTextDarkColor
        : AppColors.secondaryTextLightColor;
    final ageLabel = details.age == null
        ? ''
        : _t('${details.age} years', '${details.age} سنة');
    final department = _departmentLabel(details.department);

    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(16.w, 18.h, 18.w, 13.h),
      child: Row(
        children: [
          SizedBox(
            width: 100.w,
            child: AspectRatio(
              aspectRatio: 1,
              child: Stack(
                fit: StackFit.expand,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: double.infinity,
                    height: double.infinity,
                    padding: EdgeInsets.all(2.5.r),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.primaryColor,
                        width: 2.r,
                      ),
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(13.r),
                      child: SizedBox.expand(
                        child: _networkImage(
                          details.profileUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  [
                    if (department.isNotEmpty) department,
                    if (ageLabel.isNotEmpty) ageLabel,
                  ].join('  •  '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: secondaryColor, fontSize: 12.sp),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _tabs(bool isDark) {
    final backgroundColor = isDark
        ? AppColors.dividerDarkColor
        : AppColors.dividerLightColor;
    final borderColor = isDark
        ? AppColors.borderDarkColor
        : AppColors.borderLightColor;
    final secondaryTextColor = isDark
        ? AppColors.secondaryTextDarkColor
        : AppColors.secondaryTextLightColor;
    final titles = [
      _t('Overview', 'نظرة عامة'),
      _t('Movies', 'أفلام'),
      _t('TV Shows', 'مسلسلات'),
    ];
    return Container(
      margin: EdgeInsetsDirectional.fromSTEB(18.w, 2.h, 18.w, 0),
      height: 44.h,
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(24.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: List.generate(titles.length, (index) {
          final selected = _selectedTab == index;
          return Expanded(
            child: InkWell(
              onTap: () => setState(() => _selectedTab = index),
              borderRadius: BorderRadius.circular(22.r),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primaryColor
                      : AppColors.transparent,
                  borderRadius: BorderRadius.circular(22.r),
                ),
                child: Text(
                  titles[index],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected
                        ? AppColors.textDarkColor
                        : secondaryTextColor,
                    fontSize: 14.sp,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _tabContent(CastDetails details, bool isDark, Color textColor) {
    if (_selectedTab == 1) {
      return _creditGrid(details.movieCredits, isDark, textColor);
    }
    if (_selectedTab == 2) {
      return _creditGrid(details.tvCredits, isDark, textColor);
    }

    final secondaryColor = isDark
        ? AppColors.secondaryTextDarkColor
        : AppColors.secondaryTextLightColor;
    final knownFor = details.knownFor;
    final ratedCredits = knownFor.where((credit) => credit.rating > 0);
    final averageRating = ratedCredits.isEmpty
        ? null
        : ratedCredits.fold<double>(0, (sum, credit) => sum + credit.rating) /
              ratedCredits.length;
    final visibleKnownFor = _showAllKnownFor
        ? knownFor.take(12).toList()
        : knownFor.take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _sectionLabel(_t('BIOGRAPHY', 'السيرة الذاتية'), secondaryColor),
        SizedBox(height: 8.h),
        Text(
          details.biography.isEmpty
              ? _t('No biography available.', 'لا توجد سيرة ذاتية متاحة.')
              : details.biography,
          maxLines: _showFullBiography ? null : 4,
          overflow: _showFullBiography
              ? TextOverflow.visible
              : TextOverflow.ellipsis,
          style: TextStyle(
            color: secondaryColor,
            fontSize: 15.sp,
            height: 1.45,
          ),
        ),
        if (details.biography.length > 140)
          TextButton(
            onPressed: () =>
                setState(() => _showFullBiography = !_showFullBiography),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              _showFullBiography
                  ? _t('Read Less', 'عرض أقل')
                  : _t('Read More', 'اقرأ المزيد'),
              style: TextStyle(color: AppColors.primaryColor, fontSize: 12.sp),
            ),
          ),
        SizedBox(height: 14.h),
        _bornCard(details, isDark, textColor, secondaryColor),
        SizedBox(height: 8.h),
        Row(
          children: [
            Expanded(
              child: _statCard(
                _t('RATING', 'التقييم'),
                averageRating?.toStringAsFixed(1) ?? '—',
                '',
                isDark,
                textColor,
                secondaryColor,
                showStar: true,
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: _statCard(
                _t('KNOWN FOR', 'أعماله'),
                '${knownFor.length}',
                details.department.isEmpty
                    ? _t('Credits', 'عمل')
                    : details.department,
                isDark,
                textColor,
                secondaryColor,
              ),
            ),
          ],
        ),
        SizedBox(height: 18.h),
        Row(
          children: [
            Expanded(
              child: Text(
                _t('KNOWN FOR', 'أشهر الأعمال'),
                style: TextStyle(
                  color: textColor,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w800,
                  letterSpacing: .3,
                ),
              ),
            ),
            if (knownFor.length > 3)
              TextButton(
                onPressed: () =>
                    setState(() => _showAllKnownFor = !_showAllKnownFor),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  _showAllKnownFor
                      ? _t('Show Less', 'عرض أقل')
                      : _t('See All', 'عرض الكل'),
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontSize: 11.sp,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 8.h),
        if (visibleKnownFor.isEmpty)
          Text(
            _t('No credits available.', 'لا توجد أعمال متاحة.'),
            style: TextStyle(color: secondaryColor, fontSize: 12.sp),
          )
        else if (_showAllKnownFor)
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: visibleKnownFor.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h,
              childAspectRatio: .53,
            ),
            itemBuilder: (_, index) =>
                _creditCard(visibleKnownFor[index], textColor, secondaryColor),
          )
        else
          SizedBox(
            height: 190.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: visibleKnownFor.length,
              separatorBuilder: (_, _) => SizedBox(width: 8.w),
              itemBuilder: (_, index) => SizedBox(
                width: (MediaQuery.sizeOf(context).width - 36.w - 16.w) / 3,
                child: _creditCard(
                  visibleKnownFor[index],
                  textColor,
                  secondaryColor,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _creditGrid(List<CastCredit> credits, bool isDark, Color textColor) {
    final secondaryColor = isDark
        ? AppColors.secondaryTextDarkColor
        : AppColors.secondaryTextLightColor;
    if (credits.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(top: 48.h),
        child: Center(
          child: Text(
            _t('No credits available.', 'لا توجد أعمال متاحة.'),
            style: TextStyle(color: secondaryColor, fontSize: 14.sp),
          ),
        ),
      );
    }
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: credits.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8.w,
        mainAxisSpacing: 12.h,
        childAspectRatio: .53,
      ),
      itemBuilder: (_, index) =>
          _creditCard(credits[index], textColor, secondaryColor),
    );
  }

  Widget _creditCard(
    CastCredit credit,
    Color textColor,
    Color secondaryColor,
  ) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Expanded(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(9.r),
          child: SizedBox(
            width: double.infinity,
            child: _networkImage(credit.posterUrl, fit: BoxFit.cover),
          ),
        ),
      ),
      SizedBox(height: 4.h),
      Text(
        credit.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: textColor,
          fontSize: 12.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      Text(
        [
          if (credit.year != null) credit.year.toString(),
          if (credit.character.isNotEmpty) credit.character,
        ].join(' • '),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(color: secondaryColor, fontSize: 9.5.sp),
      ),
      if (credit.rating > 0)
        Row(
          children: [
            Icon(Icons.star_rounded, color: Colors.amber, size: 11.sp),
            SizedBox(width: 2.w),
            Text(
              credit.rating.toStringAsFixed(1),
              style: TextStyle(color: textColor, fontSize: 9.5.sp),
            ),
          ],
        ),
    ],
  );

  Widget _bornCard(
    CastDetails details,
    bool isDark,
    Color textColor,
    Color secondaryColor,
  ) {
    final birthDate = _formatDate(details.birthday);
    final ageText = details.age != null
        ? ' (${details.age} ${_t('years old', 'سنة')})'
        : '';
    final placeOfBirth = details.placeOfBirth;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.cardSurfaceDarkColor
            : AppColors.cardLightColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: isDark
              ? AppColors.borderDarkColor
              : AppColors.borderLightColor,
          width: 1.r,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cake_outlined,
              size: 20.sp,
              color: AppColors.primaryColor,
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _t('BORN', 'الميلاد'),
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: .3,
                  ),
                ),
                SizedBox(height: 3.h),
                Text(
                  '$birthDate$ageText',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13.5.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (placeOfBirth != null && placeOfBirth.isNotEmpty) ...[
                  SizedBox(height: 2.h),
                  Text(
                    placeOfBirth,
                    style: TextStyle(
                      color: secondaryColor,
                      fontSize: 11.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statCard(
    String label,
    String value,
    String subtitle,
    bool isDark,
    Color textColor,
    Color secondaryColor, {
    bool showStar = false,
  }) => Container(
    height: 80.h,
    padding: EdgeInsetsDirectional.fromSTEB(11.w, 9.h, 9.w, 9.h),
    decoration: BoxDecoration(
      color: isDark ? AppColors.cardSurfaceDarkColor : AppColors.cardLightColor,
      borderRadius: BorderRadius.circular(14.r),
      border: Border.all(
        color: isDark ? AppColors.borderDarkColor : AppColors.borderLightColor,
        width: 1.r,
      ),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: secondaryColor,
            fontSize: 11.sp,
            fontWeight: FontWeight.w700,
            letterSpacing: .3,
          ),
        ),
        SizedBox(height: 4.h),
        if (showStar)
          Row(
            children: [
              Icon(Icons.star_rounded, color: Colors.amber, size: 14.sp),
              SizedBox(width: 2.w),
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: textColor,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          )
        else
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: textColor,
              fontSize: 13.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        if (subtitle.isNotEmpty)
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: secondaryColor, fontSize: 10.sp),
          ),
      ],
    ),
  );

  Widget _sectionLabel(String label, Color color) => Text(
    label,
    style: TextStyle(
      color: color,
      fontSize: 13.sp,
      fontWeight: FontWeight.w800,
      letterSpacing: .4,
    ),
  );

  Widget _errorState(BuildContext context, String message, bool isDark) {
    final textColor = isDark
        ? AppColors.textDarkColor
        : AppColors.textLightColor;
    const primaryColor = AppColors.primaryColor;
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.r),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline_rounded, color: primaryColor, size: 42.sp),
            SizedBox(height: 12.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: textColor),
            ),
            SizedBox(height: 12.h),
            TextButton.icon(
              onPressed: context.read<CastDetailsCubit>().loadDetails,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(_t('Try Again', 'حاول مرة أخرى')),
            ),
          ],
        ),
      ),
    );
  }

  Widget _networkImage(String url, {required BoxFit fit}) {
    if (url.isEmpty) {
      return Container(
        color: AppColors.cardDarkColor,
        alignment: Alignment.center,
        child: Icon(
          Icons.person_rounded,
          color: AppColors.hintDarkColor,
          size: 30.sp,
        ),
      );
    }
    return Image.network(
      url,
      fit: fit,
      errorBuilder: (_, _, _) => Container(
        color: AppColors.cardDarkColor,
        alignment: Alignment.center,
        child: Icon(
          Icons.broken_image_outlined,
          color: AppColors.hintDarkColor,
          size: 24.sp,
        ),
      ),
    );
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return _t('Unknown', 'غير معروف');
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    if (widget.isArabic) return '${date.day}/${date.month}/${date.year}';
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }

  String _departmentLabel(String value) {
    if (value.isEmpty) return '';
    return switch (value) {
      'Acting' => _t('Actor', 'ممثل'),
      'Directing' => _t('Director', 'مخرج'),
      'Writing' => _t('Writer', 'كاتب'),
      'Production' => _t('Producer', 'منتج'),
      _ => value,
    };
  }
}
