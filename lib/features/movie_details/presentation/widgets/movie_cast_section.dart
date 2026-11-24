import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/cast_details/presentation/views/cast_details_screen.dart';
import 'package:movie_discovery_app/core/widgets/coming_soon.dart';
import 'package:movie_discovery_app/features/movie_details/domain/entities/cast.dart';

class MovieCastSection extends StatelessWidget {
  final List<Cast> cast;

  const MovieCastSection({
    super.key,
    required this.cast,
  });

  @override
  Widget build(BuildContext context) {
    if (cast.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDarkColor : AppColors.textLightColor;
    final secondaryTextColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor = isDark ? const Color(0xFF2A2F42) : const Color(0xFFCBD5E1);
    final accentColor = isDark ? const Color(0xFFD2BBFF) : AppColors.primaryColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'movie_details.top_cast'.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                    color: textColor,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () => showComingSoon(context),
                behavior: HitTestBehavior.opaque,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'movie_details.view_all'.tr(),
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: accentColor,
                      ),
                    ),
                    SizedBox(width: 2.w),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16.sp,
                      color: accentColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        SizedBox(height: 12.h),

        // Horizontal Track
        SizedBox(
          height: 105.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: cast.length,
            separatorBuilder: (_, _) => SizedBox(width: 12.w),
            itemBuilder: (context, index) {
              final member = cast[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => CastDetailsScreen(personId: member.id),
                    ),
                  );
                },
                behavior: HitTestBehavior.opaque,
                child: SizedBox(
                  width: 84.w,
                  child: Column(
                    children: [
                      // Avatar with border
                      Container(
                        width: 55.r,
                        height: 55.r,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark
                              ? const Color(0xFF171B26)
                              : const Color(0xFFE2E8F0),
                          border: Border.all(color: borderColor, width: 2),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: member.profilePath != null &&
                                member.profilePath!.isNotEmpty
                            ? Image.network(
                                member.profileUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => _placeholder(),
                              )
                            : _placeholder(),
                      ),

                      SizedBox(height: 6.h),

                      // Actor Name
                      Text(
                        member.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w600,
                          color: textColor,
                        ),
                      ),

                      // Character Name
                      if (member.character.isNotEmpty)
                        Text(
                          member.character,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: secondaryTextColor,
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
        Icons.person_rounded,
        size: 28.sp,
        color: AppColors.primaryColor.withValues(alpha: 0.6),
      ),
    );
  }
}
