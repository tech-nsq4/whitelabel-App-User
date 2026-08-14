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

/// One doctor row on the final ("pick a doctor") step of [SpecsScreen] —
/// backed by the real `GET /doctors` record.
class DoctorListTile extends StatelessWidget {
  const DoctorListTile({super.key, required this.doctor, required this.onTap});

  final DoctorProfileModel doctor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final hasImage = doctor.image != null && doctor.image!.isNotEmpty;
    final clinicName = doctor.clinic?.name;

    return AppCard(
      margin: EdgeInsets.only(bottom: 10.h),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          hasImage
              ? CustomImage(image: doctor.image!, width: 50.r, height: 50.r, radius: 16.r)
              : Container(
                  width: 50.r,
                  height: 50.r,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor.themeColor,
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  alignment: Alignment.center,
                  child: Text(doctor.avatarLetter,
                      style: TextStyle(
                          fontFamily: AppFonts.headingFont,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: primary)),
                ),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(doctor.name,
                    fontSize: 13.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
                1.height,
                AppText(
                    '${doctor.specialtyLabel} · ${LocaleKeys.booking_experienceYears.tr(namedArgs: {
                          'years': '${doctor.experienceYears}'
                        })}',
                    fontSize: 11,
                    color: AppColors.mutedColor.themeColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                // if (doctor.description != null && doctor.description!.isNotEmpty) ...[
                //   3.height,
                //   AppText(doctor.description!,
                //       fontSize: 10.5,
                //       color: AppColors.textSecondaryColor.themeColor,
                //       maxLines: 2,
                //       overflow: TextOverflow.ellipsis),
                // ],
                1.height,
                Row(
                  children: [
                    Text('${doctor.price.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                        style: TextStyle(
                            fontSize: 12.sp, fontWeight: FontWeight.w700, color: primary)),
                    if (clinicName != null && clinicName.isNotEmpty) ...[
                      6.width,
                      Expanded(
                        child: AppText('· $clinicName',
                            fontSize: 10.5,
                            color: AppColors.mutedColor.themeColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
