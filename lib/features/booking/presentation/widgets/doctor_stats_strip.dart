import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/price_text.dart';
import '../../../offers/data/models/applied_offer.dart';
import '../../data/models/doctor_profile_model.dart';

class DoctorStatsStrip extends StatelessWidget {
  const DoctorStatsStrip({super.key, required this.doctor, this.offer, this.paidPrice});

  final DoctorProfileModel doctor;
  final AppliedOffer? offer;
  final double? paidPrice;

  @override
  Widget build(BuildContext context) {
    final avgRate = doctor.avgRate;
    final offer = this.offer;
    final feeDiscount = offer != null && offer.hasClientDiscount ? offer : null;
    final paid = paidPrice ?? feeDiscount?.finalPriceFor(doctor.price) ?? doctor.price;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.themeColor,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: _Stat(
              value: LocaleKeys.booking_yearsValue.tr(namedArgs: {'years': '${doctor.experienceYears}'}),
              label: LocaleKeys.booking_experienceLabel.tr(),
            ),
          ),
          _Divider(),
          Expanded(
            child: _Stat(
              value: avgRate == null ? '—' : avgRate.toStringAsFixed(1),
              label: LocaleKeys.booking_ratingLabel.tr(),
              valueColor: avgRate == null ? null : AppColors.accentGold.themeColor,
            ),
          ),
          _Divider(),
          Expanded(
            child: _Stat(
              valueWidget: PriceText(
                amount: paid,
                strikeAmount: paid < doctor.price ? doctor.price : null,
                isHeading: true,
                fontSize: 13.5,
                strikeFontSize: 10,
                color: AppColors.primaryColor.themeColor,
                textAlign: TextAlign.center,
              ),
              label: LocaleKeys.booking_feeLabel.tr(),
              valueColor: AppColors.primaryColor.themeColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat({this.value, required this.label, this.valueColor, this.valueWidget});

  final String? value;
  final String label;
  final Color? valueColor;
  final Widget? valueWidget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        valueWidget ??
            Text(
              value ?? '',
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppFonts.headingFont,
                fontSize: 13.5.sp,
                fontWeight: FontWeight.w700,
                color: valueColor ?? AppColors.textPrimaryColor.themeColor,
              ),
            ),
        3.height,
        AppText(
          label,
          fontSize: 10,
          color: AppColors.mutedColor.themeColor,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 26.h,
      color: AppColors.dividerColor.themeColor,
    );
  }
}
