import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/cast_details/presentation/views/cast_details_screen.dart';
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
                onTap: () => _showAllCastBottomSheet(context),
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

  void _showAllCastBottomSheet(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF131722) : Colors.white;
    final textColor =
        isDark ? AppColors.textDarkColor : AppColors.textLightColor;
    final secondaryTextColor =
        isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderColor =
        isDark ? const Color(0xFF2A2F42) : const Color(0xFFE2E8F0);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (bottomSheetContext) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.4),
                blurRadius: 20,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          child: Column(
            children: [
              SizedBox(height: 12.h),
              // Drag Handle Pill
              Center(
                child: Container(
                  width: 44.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: isDark
                        ? const Color(0xFF334155)
                        : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(9999.r),
                  ),
                ),
              ),
              SizedBox(height: 14.h),
              // Header Row
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          'movie_details.top_cast'.tr(),
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: textColor,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 8.w,
                            vertical: 2.h,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            '${cast.length}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.close_rounded,
                        color: secondaryTextColor,
                        size: 22.sp,
                      ),
                      onPressed: () => Navigator.pop(bottomSheetContext),
                    ),
                  ],
                ),
              ),
              Divider(color: borderColor, height: 16.h),
              // Cast List
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 24.h),
                  itemCount: cast.length,
                  separatorBuilder: (_, _) => Divider(
                    color: borderColor.withValues(alpha: 0.5),
                    height: 10.h,
                  ),
                  itemBuilder: (context, index) {
                    final member = cast[index];
                    return InkWell(
                      borderRadius: BorderRadius.circular(12.r),
                      onTap: () {
                        Navigator.pop(bottomSheetContext);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                CastDetailsScreen(personId: member.id),
                          ),
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 6.h,
                          horizontal: 4.w,
                        ),
                        child: Row(
                          children: [
                            // Avatar
                            Container(
                              width: 50.r,
                              height: 50.r,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isDark
                                    ? const Color(0xFF1E2433)
                                    : const Color(0xFFE2E8F0),
                                border: Border.all(
                                  color: borderColor,
                                  width: 1.5,
                                ),
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
                            SizedBox(width: 14.w),
                            // Names
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    member.name,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w700,
                                      color: textColor,
                                    ),
                                  ),
                                  if (member.character.isNotEmpty) ...[
                                    SizedBox(height: 3.h),
                                    Text(
                                      member.character,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: secondaryTextColor,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Icon(
                              Icons.arrow_forward_ios_rounded,
                              size: 14.sp,
                              color: secondaryTextColor,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
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
