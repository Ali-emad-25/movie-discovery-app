import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/auth_text_field.dart';

class AccountSettingsSheetHandle extends StatelessWidget {
  final bool isDark;
  final double topPadding;
  final double bottomPadding;

  const AccountSettingsSheetHandle({
    super.key,
    required this.isDark,
    this.topPadding = 7,
    this.bottomPadding = 10,
  });

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: topPadding.h, bottom: bottomPadding.h),
    child: Container(
      width: 38.w,
      height: 4.h,
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.sheetHandleDarkColor
            : AppColors.borderLightColor,
        borderRadius: BorderRadius.circular(99.r),
      ),
    ),
  );
}

class AccountSettingsSheetTitle extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isDark;
  final double heroIconSize;
  final double titleFontSize;
  final double titleGap;

  const AccountSettingsSheetTitle({
    super.key,
    required this.icon,
    required this.title,
    required this.isDark,
    this.heroIconSize = 24,
    this.titleFontSize = 14,
    this.titleGap = 12,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Container(
        width: 74.r,
        height: 74.r,
        decoration: BoxDecoration(
          color: isDark
              ? AppColors.profileDarkColor
              : AppColors.profileLightColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryColor.withValues(alpha: 0.18),
              blurRadius: 18.r,
            ),
          ],
        ),
        child: Icon(
          icon,
          color: isDark
              ? AppColors.primaryTextDarkColor
              : AppColors.primaryColor,
          size: heroIconSize.sp,
        ),
      ),
      SizedBox(height: titleGap.h),
      Text(
        title,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.titleSmall?.copyWith(
          color: isDark ? AppColors.textDarkColor : AppColors.textLightColor,
          fontWeight: FontWeight.w700,
          fontSize: titleFontSize.sp,
        ),
      ),
    ],
  );
}

class AccountSettingsPasswordField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final bool visible;
  final double labelFontSize;
  final Widget? trailingLabel;
  final VoidCallback onToggleVisibility;
  final String? Function(String?) validator;

  const AccountSettingsPasswordField({
    super.key,
    required this.label,
    required this.hint,
    required this.controller,
    required this.visible,
    this.labelFontSize = 9,
    this.trailingLabel,
    required this.onToggleVisibility,
    required this.validator,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsetsDirectional.only(start: 2.w, bottom: 5.h),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: labelFontSize.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.45,
                    color: isDark
                        ? AppColors.secondaryTextDarkColor
                        : AppColors.secondaryTextLightColor,
                  ),
                ),
              ),
              ?trailingLabel,
            ],
          ),
        ),
        AuthTextField(
          hint: hint,
          prefixIcon: Icons.lock_outline_rounded,
          controller: controller,
          isPassword: true,
          passwordObscured: !visible,
          onTogglePasswordVisibility: onToggleVisibility,
          validator: validator,
        ),
      ],
    );
  }
}

class AccountSettingsButtonProgress extends StatelessWidget {
  const AccountSettingsButtonProgress({super.key});

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 17.r,
    height: 17.r,
    child: CircularProgressIndicator(
      strokeWidth: 2,
      color: Theme.of(context).colorScheme.onPrimary,
    ),
  );
}
