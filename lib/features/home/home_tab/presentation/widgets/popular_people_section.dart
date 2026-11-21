import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/person.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/home_section_header.dart';
import 'package:movie_discovery_app/features/home/home_tab/presentation/widgets/person_card.dart';

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HomeSectionHeader(
          title: 'home.sections.popular_people'.tr(),
          accentColor: const Color(0xFF0088FF),
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

              return PersonCard(
                person: person,
                onTap: () => onPersonTap?.call(person),
              );
            },
          ),
        ),
      ],
    );
  }
}
