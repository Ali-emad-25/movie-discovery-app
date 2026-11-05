import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

void showComingSoon(BuildContext context) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text('common.coming_soon'.tr())));
}
