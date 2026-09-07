import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../data/models/doctor_profile_model.dart';
import 'booking_slots_sheet.dart' show formatNearestAvailableDayLabel;

/// Green "nearest available slot" strip on [DoctorScreen] — renders nothing
/// when the doctor has no upcoming slot.
class DoctorNearestSlotBanner extends StatelessWidget {
  const DoctorNearestSlotBanner({super.key, required this.doctor});

  final DoctorProfileModel doctor;

  @override
  Widget build(BuildContext context) {
    final nearest = doctor.nearestAvailable;
    if (nearest == null) return const SizedBox.shrink();

    final success = AppColors.successColor.themeColor;
    final when = nearest.date == null
        ? ''
        : formatNearestAvailableDayLabel(nearest.date!, context.locale.languageCode);
    final value = [when, nearest.displayTime].where((s) => s.isNotEmpty).join(' · ');
    if (value.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Container(
            width: 26.r,
            height: 26.r,
            decoration: BoxDecoration(color: success.withValues(alpha: 0.15), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(Icons.event_available_rounded, size: 14.sp, color: success),
          ),
          10.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(LocaleKeys.booking_nearestAvailableLabel.tr(),
                    fontSize: 9.5, color: AppColors.mutedColor.themeColor),
                2.height,
                AppText(value,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: success,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
