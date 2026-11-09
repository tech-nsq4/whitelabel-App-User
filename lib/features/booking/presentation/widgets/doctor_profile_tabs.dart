import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

class DoctorProfileTabs extends StatelessWidget {
  const DoctorProfileTabs({super.key, required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.themeColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Expanded(child: _segment(0, LocaleKeys.booking_clinics.tr())),
          Expanded(child: _segment(1, LocaleKeys.booking_reviewsTab.tr())),
        ],
      ),
    );
  }

  Widget _segment(int i, String label) {
    final active = index == i;
    return CustomTapEffect(
      onTap: () => onChanged(i),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: active ? AppColors.cardColor.themeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(11.r),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: AppColors.textPrimaryColor.themeColor.withValues(alpha: 0.06),
                    blurRadius: 6,
                  ),
                ]
              : null,
        ),
        child: AppText(
          label,
          textAlign: TextAlign.center,
          fontSize: 12.5,
          fontWeight: active ? FontWeight.w600 : FontWeight.w500,
          color: active
              ? AppColors.textPrimaryColor.themeColor
              : AppColors.mutedColor.themeColor,
        ),
      ),
    );
  }
}
