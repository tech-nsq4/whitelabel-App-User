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

/// The branch / experience / fee strip under [DoctorHeroHeader] on the
/// redesigned [DoctorScreen].
class DoctorProfileStats extends StatelessWidget {
  const DoctorProfileStats({super.key, required this.doctor, this.offer});

  final DoctorProfileModel doctor;
  final AppliedOffer? offer;

  String get _branchValue {
    final clinics = doctor.clinics;
    if (clinics.length == 1) return clinics.first.name;
    if (clinics.length > 1) {
      return LocaleKeys.booking_clinicsCount.tr(namedArgs: {'count': '${clinics.length}'});
    }
    return doctor.location?.name ?? '—';
  }

  @override
  Widget build(BuildContext context) {
    final finalPrice = offer?.finalPriceFor(doctor.price) ?? doctor.price;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.themeColor,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.dividerColor.themeColor),
      ),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 6.w),
      child: Row(
        children: [
          Expanded(child: _Cell(value: _branchValue, label: LocaleKeys.booking_branchLabel.tr())),
          _Divider(),
          Expanded(
            child: _Cell(
              value: LocaleKeys.booking_yearsValue.tr(namedArgs: {'years': '${doctor.experienceYears}'}),
              label: LocaleKeys.booking_experienceLabel.tr(),
            ),
          ),
          _Divider(),
          Expanded(
            child: _Cell(
              label: LocaleKeys.booking_feeLabel.tr(),
              valueWidget: PriceText(
                amount: finalPrice,
                strikeAmount: doctor.price,
                isHeading: true,
                fontSize: 11,
                strikeFontSize: 9.5,
                color: AppColors.primaryColor.themeColor,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell({this.value, this.valueWidget, required this.label});

  final String? value;
  final Widget? valueWidget;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        valueWidget ??
            Text(
              value ?? '',
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontFamily: AppFonts.headingFont,
                fontSize: 10.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryColor.themeColor,
              ),
            ),
        3.height,
        AppText(label,
            fontSize: 9.5,
            color: AppColors.mutedColor.themeColor,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis),
      ],
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 26.h, color: AppColors.dividerColor.themeColor);
  }
}
