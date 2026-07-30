import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'app_text.dart';

/// Eyebrow section title with an optional trailing "see all" action —
/// used above the services grid, medical record list, and specialty lists.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.actionLabel,
    this.onActionTap,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onActionTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 10.sp,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.4,
            color: AppColors.mutedColor.themeColor,
          ),
        ),
        if (actionLabel != null)
          GestureDetector(
            onTap: onActionTap,
            child: AppText(
              actionLabel!,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: AppColors.primaryColor.themeColor,
            ),
          ),
      ],
    );
  }
}
