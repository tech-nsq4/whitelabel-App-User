import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

/// Label shown above a [CustomTextField] on the auth forms.
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
