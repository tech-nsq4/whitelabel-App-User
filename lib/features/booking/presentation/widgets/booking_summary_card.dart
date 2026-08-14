import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';

/// Doctor/appointment/branch/price summary at the bottom of
/// [BookingSlotsSheet], right above the pay button.
class BookingSummaryCard extends StatelessWidget {
  const BookingSummaryCard({
    super.key,
    required this.doctorName,
    required this.whenLabel,
    required this.clinicName,
    required this.priceLabel,
    this.patientName,
  });

  final String doctorName;
  final String whenLabel;
  final String? clinicName;
  final String priceLabel;

  /// The family member this appointment is for — omitted (row hidden)
  /// when booking for the account holder.
  final String? patientName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.themeColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row(LocaleKeys.booking_doctorLabel.tr(), doctorName),
          if (patientName != null && patientName!.isNotEmpty)
            _row(LocaleKeys.booking_patientLabel.tr(), patientName!),
          _row(LocaleKeys.booking_appointmentLabel.tr(), whenLabel),
          if (clinicName != null && clinicName!.isNotEmpty) _row(LocaleKeys.booking_branchLabel.tr(), clinicName!),
          _row(LocaleKeys.booking_priceLabel.tr(), priceLabel),
        ],
      ),
    );
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: TextStyle(fontSize: 11.sp, color: AppColors.mutedColor.themeColor)),
          Text(v,
              style: TextStyle(
                  fontSize: 12.sp, fontWeight: FontWeight.w600, color: AppColors.textPrimaryColor.themeColor)),
        ],
      ),
    );
  }
}
