import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/person.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/home_section_header.dart';

class PopularPeopleSection extends StatelessWidget {
  final List<Person> people;
  final VoidCallback? onSeeAll;
  final void Function(Person person)? onPersonTap;

  const PopularPeopleSection({
    super.key,
    required this.people,
    this.onSeeAll,
    this.onPersonTap,
  });

  @override
  Widget build(BuildContext context) {
    if (people.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDarkColor : AppColors.textLightColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: 'home.sections.popular_people'.tr(),
          accentColor: const Color(0xFF0088FF), // Blue accent from Figma
          onSeeAll: onSeeAll,
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 128.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: people.length,
            separatorBuilder: (_, _) => SizedBox(width: 14.w),
            itemBuilder: (context, index) {
              final person = people[index];
              return GestureDetector(
                onTap: () => onPersonTap?.call(person),
                child: SizedBox(
                  width: 82.w,
                  child: Column(
                    children: [
                      // Circular Avatar
                      Container(
                        width: 80.r,
                        height: 80.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isDark
                                ? const Color(0xFF262A35)
                                : const Color(0xFFCBD5E1),
                            width: 2,
                          ),
                          color: isDark
                              ? const Color(0xFF171B26)
                              : const Color(0xFFE2E8F0),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: person.profilePath != null &&
                                person.profilePath!.isNotEmpty
                            ? Image.network(
                                person.profileUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => _placeholder(),
                              )
                            : _placeholder(),
                      ),

                      SizedBox(height: 8.h),

                      // Name
                      Text(
                        person.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Center(
      child: Icon(
        Icons.person_outline_rounded,
        size: 36.sp,
        color: AppColors.primaryColor.withValues(alpha: 0.6),
      ),
    );
  }
}
