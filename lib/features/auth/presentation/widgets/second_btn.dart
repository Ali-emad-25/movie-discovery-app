import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_assets.dart';

class SecondBtn extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isGoogle;

  const SecondBtn({
    super.key,
    required this.text,
    required this.onPressed,
    this.isGoogle = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: colors.surface,
          foregroundColor: colors.onSurface,
          padding: EdgeInsets.zero,
          side: BorderSide(color: theme.dividerColor),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(999.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isGoogle) ...[
              Image.asset(AppAssets.googleLogo, width: 20.w, height: 20.h),
              SizedBox(width: 10.w),
            ],

            Text(
              text,
              style: theme.textTheme.labelLarge?.copyWith(
                color: colors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
