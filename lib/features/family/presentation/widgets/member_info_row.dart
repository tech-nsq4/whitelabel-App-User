import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

/// One label/value line in the info card on [MemberScreen].
class MemberInfoRow extends StatelessWidget {
  const MemberInfoRow({super.key, required this.label, required this.value, this.showDivider = true});

  final String label;
  final String value;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        border: showDivider ? Border(bottom: BorderSide(color: AppColors.dividerColor.themeColor)) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AppText(label, fontSize: 12, color: AppColors.mutedColor.themeColor),
          AppText(value, fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimaryColor.themeColor),
        ],
      ),
    );
  }
}
