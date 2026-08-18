import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../app/router/routes.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';

/// Shown on [MyBookingsScreen] instead of the list when the account has no
/// booked appointments yet — mirrors [NoSlotsView]'s empty-state layout.
class NoBookingsView extends StatelessWidget {
  const NoBookingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 12.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.mutedColor.themeColor.withValues(alpha: 0.12),
              ),
              child: Icon(Icons.event_busy_rounded, color: AppColors.mutedColor.themeColor, size: 30.sp),
            ),
            16.height,
            AppText(LocaleKeys.booking_noBookingsTitle.tr(),
                isHeading: true,
                fontSize: 15,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryColor.themeColor),
            6.height,
            AppText(LocaleKeys.booking_noBookingsDescription.tr(),
                fontSize: 11.5,
                textAlign: TextAlign.center,
                color: AppColors.mutedColor.themeColor,
                height: 1.6),
            20.height,
            CustomButton(
              title: LocaleKeys.home_bookAppointment.tr(),
              onTap: () => Navigator.pushNamed(context, Routes.book),
            ),
          ],
        ),
      ),
    );
  }
}
