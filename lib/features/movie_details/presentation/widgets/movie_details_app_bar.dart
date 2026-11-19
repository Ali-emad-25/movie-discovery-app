import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';

class MovieDetailsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String movieTitle;
  final VoidCallback onBack;

  const MovieDetailsAppBar({
    super.key,
    required this.movieTitle,
    required this.onBack,
  });

  @override
  Size get preferredSize => Size.fromHeight(56.h);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.textDarkColor : AppColors.textLightColor;
    final iconColor = isDark ? Colors.white : AppColors.textLightColor;

    return AppBar(
      backgroundColor: isDark
          ? const Color(0xFF0F131D)
          : Colors.white,
      elevation: 0,
      centerTitle: false,
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back_rounded,
          color: iconColor,
          size: 22.sp,
        ),
        onPressed: onBack,
      ),
      titleSpacing: 0,
      title: Text(
        'movie_details.title'.tr(),
        style: TextStyle(
          color: textColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.share_outlined,
            color: iconColor,
            size: 20.sp,
          ),
          onPressed: () {
            Fluttertoast.showToast(
              msg: context.locale.languageCode == 'ar'
                  ? 'تم نسخ رابط $movieTitle'
                  : 'Link for "$movieTitle" copied',
              toastLength: Toast.LENGTH_SHORT,
              backgroundColor: const Color(0xFF171B26),
              textColor: Colors.white,
            );
          },
        ),
        Padding(
          padding: EdgeInsetsDirectional.only(end: 16.w, start: 4.w),
          child: Center(
            child: Container(
              width: 32.r,
              height: 32.r,
              decoration: const BoxDecoration(
                color: Color(0xFFD2BBFF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person_rounded,
                size: 18.sp,
                color: const Color(0xFF171B26),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
