import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTextField extends StatefulWidget {
  final String hint;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;

  const AuthTextField({
    super.key,
    required this.hint,
    required this.prefixIcon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return SizedBox(
      height: 50.h,
      child: TextField(
        controller: widget.controller,
        obscureText: widget.isPassword && obscureText,
        keyboardType: widget.keyboardType,
        style: theme.textTheme.displayLarge,
        decoration: InputDecoration(
          hintText: widget.hint,
          prefixIcon: Padding(
            padding: EdgeInsetsDirectional.only(start: 8.0.w),
            child: Icon(
              widget.prefixIcon,
              size: 18.sp,
              color: colors.onPrimary,
            ),
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                  icon: Icon(
                    obscureText
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 17.sp,
                    color: colors.onPrimary,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
