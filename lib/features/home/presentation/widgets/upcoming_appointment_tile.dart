import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

/// Compact "next appointment" summary: day/month, doctor + clinic, time.
class UpcomingAppointmentTile extends StatelessWidget {
  const UpcomingAppointmentTile({
    super.key,
    required this.day,
    required this.month,
    required this.time,
    required this.period,
    this.onTap,
  });

  final String day;
  final String month;
  final String time;
  final String period;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return CustomTapEffect(
      onTap: onTap ?? () {},
      isClickable: onTap != null,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.dividerColor.themeColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimaryColor.themeColor
                  .withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsetsDirectional.only(end: 14.w),
              decoration: BoxDecoration(
                border: BorderDirectional(
                  end: BorderSide(color: AppColors.dividerColor.themeColor),
                ),
              ),
              child: Column(
                children: [
                  Text(
                    day,
                    style: TextStyle(
                      fontFamily: AppFonts.headingFont,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: primary,
                      height: 1,
                    ),
                  ),
                  AppText(
                    month,
                    fontSize: 10,
                    color: AppColors.mutedColor.themeColor,
                  ),
                ],
              ),
            ),
            14.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    LocaleKeys.home_doctorName.tr(),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimaryColor.themeColor,
                  ),
                  3.height,
                  AppText(
                    LocaleKeys.home_clinicBranch.tr(),
                    fontSize: 11,
                    color: AppColors.mutedColor.themeColor,
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontFamily: AppFonts.headingFont,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor,
                  ),
                ),
                Text(
                  period,
                  style: TextStyle(
                    fontFamily: AppFonts.bodyFont,
                    fontSize: 10.sp,
                    color: AppColors.mutedColor.themeColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
