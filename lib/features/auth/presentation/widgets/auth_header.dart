import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_assets.dart';

class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Column(
      children: [
        Container(
          width: 64.w,
          height: 64.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: colors.primary.withValues(alpha:  0.25),
                blurRadius: 20.r,
                spreadRadius: 10.r,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15.r),
            child: Image.asset(AppAssets.logo, fit: BoxFit.cover),
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Movie', style: theme.textTheme.titleLarge),
            Text('Verse', style: theme.textTheme.titleMedium),
          ],
        ),
      ],
    );
  }
}
