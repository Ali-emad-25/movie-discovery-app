import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:movie_discovery_app/core/utils/app_colors.dart';
import 'package:movie_discovery_app/features/auth/presentation/widgets/auth_text_field.dart';

class AccountProfileAvatar extends StatelessWidget {
  final String name;
  final String? photoUrl;
  final VoidCallback onEdit;

  const AccountProfileAvatar({
    super.key,
    required this.name,
    required this.photoUrl,
    required this.onEdit,
  });

  String get _initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty);
    return parts.take(2).map((part) => part[0].toUpperCase()).join();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 82.r,
      height: 82.r,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 76.r,
            height: 76.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [
                  AppColors.primaryColor,
                  AppColors.primaryTextDarkColor,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withValues(alpha: 0.25),
                  blurRadius: 14.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: photoUrl?.isNotEmpty != true
                ? _initialLabel
                : photoUrl!.startsWith('http://') ||
                      photoUrl!.startsWith('https://')
                ? Image.network(
                    photoUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _initialLabel,
                  )
                : Image.file(
                    File(photoUrl!),
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => _initialLabel,
                  ),
          ),
          PositionedDirectional(
            end: 0,
            bottom: 0,
            child: InkWell(
              onTap: onEdit,
              customBorder: const CircleBorder(),
              child: Container(
                width: 24.r,
                height: 24.r,
                decoration: BoxDecoration(
                  color: AppColors.primaryColor,
                  shape: BoxShape.circle,
                  border: Border.all(color: AppColors.bgDarkColor, width: 1.5),
                ),
                child: Icon(
                  Icons.edit_rounded,
                  size: 12.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget get _initialLabel => Center(
    child: Text(
      _initials.isEmpty ? 'U' : _initials,
      style: TextStyle(
        color: Colors.white,
        fontSize: 24.sp,
        fontWeight: FontWeight.w700,
      ),
    ),
  );
}

class AccountNameField extends StatefulWidget {
  final String value;
  final bool isEditing;
  final TextEditingController controller;

  const AccountNameField({
    super.key,
    required this.value,
    required this.isEditing,
    required this.controller,
  });

  @override
  State<AccountNameField> createState() => _AccountNameFieldState();
}

class _AccountNameFieldState extends State<AccountNameField> {
  @override
  void initState() {
    super.initState();
    _syncController(widget.value);
  }

  @override
  void didUpdateWidget(covariant AccountNameField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget.isEditing && oldWidget.value != widget.value) {
      _syncController(widget.value);
    }
  }

  void _syncController(String value) {
    if (widget.controller.text == value) return;
    widget.controller.value = TextEditingValue(
      text: value,
      selection: TextSelection.collapsed(offset: value.length),
    );
  }

  @override
  Widget build(BuildContext context) => AuthTextField(
    key: ValueKey(widget.isEditing),
    hint: '',
    prefixIcon: Icons.person_outline,
    controller: widget.controller,
    autofocus: widget.isEditing,
    readOnly: !widget.isEditing,
    textCapitalization: TextCapitalization.words,
    textInputAction: TextInputAction.done,
    textStyle: Theme.of(
      context,
    ).textTheme.bodyMedium?.copyWith(fontSize: 15.sp),
  );
}
