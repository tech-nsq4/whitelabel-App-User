import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/image/custom_image.dart';
import '../../data/models/doctor_profile_model.dart';

/// Avatar/name/specialty card at the top of [DoctorScreen] — the fields it
/// shows are exactly what `GET /doctors` returns, no rating/reviews/bio
/// placeholders since the API doesn't have those yet.
class DoctorProfileHeader extends StatelessWidget {
  const DoctorProfileHeader({super.key, required this.doctor});

  final DoctorProfileModel doctor;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final hasImage = doctor.image != null && doctor.image!.isNotEmpty;
    final clinicName = doctor.clinic?.name;

    return AppCard(
      margin: EdgeInsets.only(bottom: 14.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          hasImage
              ? CustomImage(image: doctor.image!, width: 62.r, height: 62.r, radius: 20.r)
              : Container(
                  width: 62.r,
                  height: 62.r,
                  decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(20.r)),
                  alignment: Alignment.center,
                  child: Text(doctor.avatarLetter,
                      style: TextStyle(
                          fontFamily: AppFonts.headingFont,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
          14.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(doctor.name,
                    isHeading: true, fontSize: 17, color: AppColors.textPrimaryColor.themeColor),
                if (doctor.specialtyLabel.isNotEmpty) ...[
                  2.height,
                  AppText(doctor.specialtyLabel, fontSize: 12, fontWeight: FontWeight.w600, color: primary),
                ],
                7.height,
                Wrap(spacing: 6.w, runSpacing: 6.h, children: [
                  if (clinicName != null && clinicName.isNotEmpty) _Pill(clinicName),
                  _Pill(LocaleKeys.booking_experienceYears
                      .tr(namedArgs: {'years': '${doctor.experienceYears}'})),
                  _Pill('${doctor.price.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}'),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  const _Pill(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 6.h),
      decoration:
          BoxDecoration(color: AppColors.surfaceColor.themeColor, borderRadius: BorderRadius.circular(99)),
      child: Text(text,
          style: TextStyle(
              fontSize: 11.sp, fontWeight: FontWeight.w500, color: AppColors.textSecondaryColor.themeColor)),
    );
  }
}
