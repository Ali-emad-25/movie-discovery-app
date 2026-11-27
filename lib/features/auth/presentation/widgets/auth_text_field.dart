import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTextField extends StatefulWidget {
  final String hint;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool autofocus;
  final bool readOnly;
  final TextCapitalization textCapitalization;
  final TextInputAction? textInputAction;
  final bool? passwordObscured;
  final VoidCallback? onTogglePasswordVisibility;
  final TextStyle? textStyle;

  const AuthTextField({
    super.key,
    required this.hint,
    required this.prefixIcon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.isPassword = false,
    this.validator,
    this.enabled = true,
    this.autofocus = false,
    this.readOnly = false,
    this.textCapitalization = TextCapitalization.none,
    this.textInputAction,
    this.passwordObscured,
    this.onTogglePasswordVisibility,
    this.textStyle,
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
    final passwordObscured = widget.passwordObscured ?? obscureText;

    return IgnorePointer(
      ignoring: widget.readOnly,
      child: TextFormField(
        controller: widget.controller,
        keyboardType: widget.keyboardType,
        textCapitalization: widget.textCapitalization,
        textInputAction: widget.textInputAction,
        autofocus: widget.autofocus,
        readOnly: widget.readOnly,
        showCursor: !widget.readOnly,
        obscureText: widget.isPassword && passwordObscured,
        validator: widget.validator,
        enabled: widget.enabled,
        style: widget.textStyle ?? theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: widget.hint,
          prefixIcon: Icon(
            widget.prefixIcon,
            size: 18.sp,
            color: colors.onSurface.withValues(alpha: 0.65),
          ),
          suffixIcon: widget.isPassword
              ? IconButton(
                  onPressed:
                      widget.onTogglePasswordVisibility ??
                      () => setState(() => obscureText = !obscureText),
                  icon: Icon(
                    passwordObscured
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 17.sp,
                    color: colors.onSurface.withValues(alpha: 0.65),
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
