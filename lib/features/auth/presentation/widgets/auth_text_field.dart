import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AuthTextField extends StatefulWidget {
  final String hint;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextInputAction? textInputAction;
  final bool isPassword;
  final String? Function(String?)? validator;
  final bool enabled;
  final bool autofocus;
  final bool readOnly;
  final TextCapitalization textCapitalization;
  final bool? passwordObscured;
  final VoidCallback? onTogglePasswordVisibility;
  final TextStyle? textStyle;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onFieldSubmitted;
  final Widget? suffixIcon;

  const AuthTextField({
    super.key,
    required this.hint,
    required this.prefixIcon,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.isPassword = false,
    this.validator,
    this.enabled = true,
    this.autofocus = false,
    this.readOnly = false,
    this.textCapitalization = TextCapitalization.none,
    this.passwordObscured,
    this.onTogglePasswordVisibility,
    this.textStyle,
    this.onChanged,
    this.onFieldSubmitted,
    this.suffixIcon,
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
        textInputAction: widget.textInputAction,
        textCapitalization: widget.textCapitalization,
        autofocus: widget.autofocus,
        readOnly: widget.readOnly,
        showCursor: !widget.readOnly,
        obscureText: widget.isPassword && passwordObscured,
        validator: widget.validator,
        enabled: widget.enabled,
        onChanged: widget.onChanged,
        onFieldSubmitted: widget.onFieldSubmitted,
        style: widget.textStyle ?? theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          hintText: widget.hint,
          prefixIcon: Icon(
            widget.prefixIcon,
            size: 20.sp,
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
              : widget.suffixIcon,
        ),
      ),
    );
  }
}
