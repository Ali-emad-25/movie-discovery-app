import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_styles.dart';

class TextBtn extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const TextBtn({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: EdgeInsetsDirectional.only(end: 10.h),
        child: InkWell(
          onTap: onTap,
          child: Text(text, style: AppStyles.med12Primary),
        ),
      ),
    );
  }
}
