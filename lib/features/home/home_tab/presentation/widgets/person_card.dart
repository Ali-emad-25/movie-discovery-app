import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/home/home_tab/domain/entities/person.dart';

class PersonCard extends StatelessWidget {
  final Person person;
  final VoidCallback? onTap;
  final double? width;
  final double? imageSize;

  const PersonCard({
    super.key,
    required this.person,
    this.onTap,
    this.width,
    this.imageSize,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark
        ? AppColors.textDarkColor
        : AppColors.textLightColor;

    final avatarSize = imageSize ?? 80.r;

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width ?? 82.w,
        child: Column(
          children: [
            Container(
              width: avatarSize,
              height: avatarSize,
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
              child:
                  person.profilePath != null && person.profilePath!.isNotEmpty
                  ? Image.network(
                      person.profileUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _placeholder(),
                    )
                  : _placeholder(),
            ),
            SizedBox(height: 8.h),
            Text(
              person.name,
              maxLines: 2,
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
