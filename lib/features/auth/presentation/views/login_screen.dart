import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('ali_emad'.tr()), // متنساش تكتب ()tr. بعد كل key علشان الترجمه
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 40.w),
              ),
              onPressed: () {
                context.setLocale(
                  Locale(context.locale.languageCode == 'en' ? 'ar' : 'en'),
                );
              },
              child: Text(context.locale.languageCode == 'en' ? 'ar' : 'en'),
            ),
          ],
        ),
      ),
    );
  }
}
