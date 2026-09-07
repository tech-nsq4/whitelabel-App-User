import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/image/custom_image.dart';
import '../../../../core/widgets/star_rating.dart';
import '../../data/models/doctor_profile_model.dart';

/// Centred doctor summary at the top of the redesigned [DoctorScreen] —
/// avatar, name, rating stars, specialty and quick chips.
class DoctorHeroHeader extends StatelessWidget {
  const DoctorHeroHeader({super.key, required this.doctor});

  final DoctorProfileModel doctor;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final hasImage = doctor.image != null && doctor.image!.isNotEmpty;
    final avgRate = doctor.avgRate;

    return Column(
      children: [
        if (hasImage)
          CustomImage(image: doctor.image!, width: 80.r, height: 80.r, radius: 20.r)
        else
          Container(
            width: 80.r,
            height: 80.r,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [primary, AppColors.primaryLightColor.themeColor],
              ),
              borderRadius: BorderRadius.circular(20.r),
            ),
            alignment: Alignment.center,
            child: Text(doctor.avatarLetter,
                style: TextStyle(
                    fontFamily: AppFonts.headingFont,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white)),
          ),
        12.height,
        AppText(doctor.name,
            isHeading: true,
            fontSize: 18,
            fontWeight: FontWeight.w600,
            textAlign: TextAlign.center,
            color: AppColors.textPrimaryColor.themeColor),
        if (avgRate != null) ...[
          6.height,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StarRating(value: avgRate, size: 13, spacing: 2),
              6.width,
              Text(avgRate.toStringAsFixed(1),
                  style: TextStyle(
                      fontSize: 11.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryColor.themeColor)),
            ],
          ),
        ],
        if (doctor.specialtyLabel.isNotEmpty) ...[
          6.height,
          AppText(doctor.specialtyLabel,
              fontSize: 12.5,
              color: AppColors.textSecondaryColor.themeColor,
              textAlign: TextAlign.center,
              maxLines: 2),
        ],
        if (doctor.experienceYears > 0) ...[
          10.height,
          _Chip(LocaleKeys.booking_experienceYears
              .tr(namedArgs: {'years': '${doctor.experienceYears}'})),
        ],
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.themeColor,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10.5.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondaryColor.themeColor)),
    );
  }
}
