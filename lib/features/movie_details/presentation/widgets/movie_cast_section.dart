import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
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
        isDark ? AppColors.secondaryTextDarkColor : AppColors.secondaryTextLightColor;
    final borderColor = isDark ? AppColors.borderDarkColor : AppColors.borderLightColor;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            'Top Cast',
            style: TextStyle(
              color: textColor,
              fontSize: 17.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: -0.3,
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          height: 115.h,
          child: ListView.separated(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            scrollDirection: Axis.horizontal,
            itemCount: cast.length,
            separatorBuilder: (_, _) => SizedBox(width: 14.w),
            itemBuilder: (context, index) {
              final member = cast[index];
              return SizedBox(
                width: 72.w,
                child: Column(
                  children: [
                    // Actor Avatar
                    Container(
                      width: 58.r,
                      height: 58.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: borderColor,
                          width: 1.5,
                        ),
                      ),
                      child: ClipOval(
                        child: member.profileUrl.isNotEmpty
                            ? Image.network(
                                member.profileUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => _avatarPlaceholder(isDark),
                              )
                            : _avatarPlaceholder(isDark),
                      ),
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      member.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      member.character,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: secondaryTextColor,
                        fontSize: 10.sp,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _avatarPlaceholder(bool isDark) {
    return Container(
      color: isDark ? const Color(0xFF222838) : const Color(0xFFE2E8F0),
      child: const Center(
        child: Icon(
          Icons.person_rounded,
          color: AppColors.primaryColor,
          size: 26,
        ),
      ),
    );
  }
}

