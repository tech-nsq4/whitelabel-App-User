import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

/// Shown on [BookingSlotsSheet] instead of the calendar when the doctor has
/// no `clinic`-type time-table at all (`DoctorAvailability.isEmpty`) — an
/// empty calendar with nothing highlighted would just read as broken.
class NoSlotsView extends StatelessWidget {
  const NoSlotsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
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
          AppText(LocaleKeys.booking_noAppointmentsTitle.tr(),
              isHeading: true,
              fontSize: 15,
              textAlign: TextAlign.center,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryColor.themeColor),
          6.height,
          AppText(LocaleKeys.booking_noAppointmentsDescription.tr(),
              fontSize: 11.5,
              textAlign: TextAlign.center,
              color: AppColors.mutedColor.themeColor,
              height: 1.6),
        ],
      ),
    );
  }
}
