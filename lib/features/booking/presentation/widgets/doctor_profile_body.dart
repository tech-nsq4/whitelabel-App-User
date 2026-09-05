import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/section_header.dart';
import '../../data/models/doctor_profile_model.dart';
import 'doctor_clinic_card.dart';
import 'doctor_profile_header.dart';
import 'doctor_specializations_section.dart';

class DoctorProfileBody extends StatelessWidget {
  const DoctorProfileBody({super.key, required this.doctor, required this.onBook});

  final DoctorProfileModel doctor;
  final void Function(int? clinicId) onBook;

  @override
  Widget build(BuildContext context) {
    final description = doctor.description;
    final clinics = doctor.clinics;

    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.only(top: 6.h, bottom: 104.h),
          children: [
            DoctorProfileHeader(doctor: doctor),
            if (description != null && description.isNotEmpty) ...[
              SectionHeader(title: LocaleKeys.booking_about.tr()),
              10.height,
              AppCard(
                margin: EdgeInsets.only(bottom: 16.h),
                child: AppText(description,
                    fontSize: 12.5, color: AppColors.textSecondaryColor.themeColor, height: 1.8),
              ),
            ],
            DoctorSpecializationsSection(doctor: doctor),
            if (clinics.isNotEmpty) ...[
              SectionHeader(
                title: clinics.length > 1
                    ? '${LocaleKeys.booking_clinics.tr()} (${clinics.length})'
                    : LocaleKeys.booking_clinics.tr(),
              ),
              10.height,
              for (final clinic in clinics)
                DoctorClinicCard(clinic: clinic, onBook: () => onBook(clinic.id)),
            ],
          ],
        ),
        Positioned(
          bottom: 8.h,
          left: 0,
          right: 0,
          child: _BookBar(doctor: doctor, onBook: () => onBook(null)),
        ),
      ],
    );
  }
}

class _BookBar extends StatelessWidget {
  const _BookBar({required this.doctor, required this.onBook});

  final DoctorProfileModel doctor;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.r),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.dividerColor.themeColor),
        boxShadow: [
          BoxShadow(
            color: AppColors.textPrimaryColor.themeColor.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              AppText(LocaleKeys.booking_feeLabel.tr(),
                  fontSize: 9.5, color: AppColors.mutedColor.themeColor),
              2.height,
              Text(
                '${doctor.price.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
                style: TextStyle(
                  fontFamily: AppFonts.headingFont,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryColor.themeColor,
                ),
              ),
            ],
          ),
          14.width,
          Expanded(
            child: CustomButton(
              title: LocaleKeys.booking_availableAppointments.tr(),
              onTap: onBook,
            ),
          ),
        ],
      ),
    );
  }
}
