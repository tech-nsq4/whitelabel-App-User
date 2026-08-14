import 'package:flutter/material.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';

/// Small bold label shown above a [CustomTextField] on a form — used across
/// the auth and profile-completion forms.
class FieldLabel extends StatelessWidget {
  const FieldLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: AppText(
        text,
        fontSize: 14,
        color: AppColors.primaryColor.themeColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
