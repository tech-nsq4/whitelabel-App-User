import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

/// Shown on [HomeScreen] instead of [UpcomingAppointmentTile] when the
/// account has no upcoming appointment yet — a CTA into the booking flow.
class NoUpcomingAppointmentTile extends StatelessWidget {
  const NoUpcomingAppointmentTile({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.r),
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.dividerColor.themeColor),
        ),
        child: Row(
          children: [
            Icon(Icons.event_available_outlined, color: AppColors.primaryColor.themeColor, size: 26.sp),
            12.width,
            Expanded(
              child: AppText(
                LocaleKeys.home_noUpcomingAppointment.tr(),
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: AppColors.mutedColor.themeColor,
              ),
            ),
            8.width,
            AppText(
              LocaleKeys.home_bookAppointment.tr(),
              fontSize: 12.5,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryColor.themeColor,
            ),
          ],
        ),
      ),
    );
  }
}
