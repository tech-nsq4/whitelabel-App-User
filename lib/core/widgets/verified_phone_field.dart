import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import 'app_text_field.dart';

/// Read-only phone field with a "verified" badge — the user's phone is the
/// OTP-verified identity, so it's shown but never editable on the
/// complete-profile / edit-profile forms.
class VerifiedPhoneField extends StatelessWidget {
  const VerifiedPhoneField({super.key, required this.hint, required this.phone});

  final String hint;
  final String phone;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      hint: hint,
      controller: TextEditingController(text: phone),
      enabled: false,
      suffixIcon: Icon(
        Icons.verified_rounded,
        color: AppColors.successColor.themeColor,
        size: 18,
      ),
    );
  }
}
