import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

enum ToastType { success, error }

class AppToast {
  static Future<bool?> show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.success,
    Duration duration = const Duration(seconds: 3),
  }) {
    final isSuccess = type == ToastType.success;

    return Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: duration.inSeconds,
      backgroundColor: isSuccess
          ? const Color(0xFF16A34A)
          : const Color(0xFFDC2626),
      textColor: Colors.white,
      fontSize: 14,
    );
  }

  static Future<bool?> success(
    BuildContext context, {
    required String message,
  }) {
    return show(context, message: message);
  }

  static Future<bool?> error(BuildContext context, {required String message}) {
    return show(context, message: message, type: ToastType.error);
  }
}
