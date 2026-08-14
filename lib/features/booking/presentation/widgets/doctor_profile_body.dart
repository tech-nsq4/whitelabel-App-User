import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/doctor_profile_model.dart';
import 'doctor_clinic_card.dart';
import 'doctor_profile_header.dart';

/// Scrollable profile content + floating "book" button for [DoctorScreen],
/// once the real `GET /doctors/{id}` record has loaded.
class DoctorProfileBody extends StatelessWidget {
  const DoctorProfileBody({super.key, required this.doctor, required this.onBook});

  final DoctorProfileModel doctor;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final description = doctor.description;

    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.only(top: 6.h, bottom: 90.h),
          children: [
            DoctorProfileHeader(doctor: doctor),
            if (description != null && description.isNotEmpty) ...[
              Text(LocaleKeys.booking_about.tr(),
                  style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: AppColors.mutedColor.themeColor)),
              10.height,
              AppCard(
                margin: EdgeInsets.only(bottom: 14.h),
                child: AppText(description,
                    fontSize: 12.5, color: AppColors.textSecondaryColor.themeColor, height: 1.8),
              ),
            ],
            if (doctor.clinic case final clinic?) ...[
              Text(LocaleKeys.booking_clinicInfo.tr(),
                  style: TextStyle(
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                      color: AppColors.mutedColor.themeColor)),
              10.height,
              DoctorClinicCard(clinic: clinic),
            ],
          ],
        ),
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            color: AppColors.backgroundColor.themeColor,
            child: CustomButton(
              title: LocaleKeys.booking_availableAppointments.tr(),
              onTap: onBook,
            ),
          ),
        ),
      ],
    );
  }
}
