import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class DoctorCardStatCell extends StatelessWidget {
  const DoctorCardStatCell({super.key, this.value, this.valueWidget, required this.label, this.valueColor});

  final String? value;
  final Widget? valueWidget;
  final String label;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        valueWidget ??
            AppText(
              value ?? '',
              isHeading: true,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              color: valueColor ?? AppColors.textPrimaryColor.themeColor,
            ),
        3.height,
        AppText(
          label,
          fontSize: 9.5,
          color: AppColors.mutedColor.themeColor,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
