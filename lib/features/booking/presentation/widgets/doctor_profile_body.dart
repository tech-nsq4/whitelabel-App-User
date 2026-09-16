import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../offers/data/models/applied_offer.dart';
import '../../data/models/doctor_profile_model.dart';
import 'doctor_book_bar.dart';
import 'doctor_clinic_card.dart';
import 'doctor_hero_header.dart';
import 'doctor_nearest_slot_banner.dart';
import 'doctor_offer_banner.dart';
import 'doctor_profile_stats.dart';
import 'doctor_reviews_tab.dart';
import 'doctor_specializations_section.dart';

/// The scrolling body of [DoctorScreen] — the redesigned doctor summary, then
/// a two-tab section (clinics / reviews), with the fee + book CTA pinned to
/// the bottom. [onBook] carries the picked clinic id (`null` from the pinned
/// bar — the slot sheet then picks a clinic when there's more than one).
class DoctorProfileBody extends StatefulWidget {
  const DoctorProfileBody({super.key, required this.doctor, required this.onBook, this.offer});

  final DoctorProfileModel doctor;
  final void Function(int? clinicId) onBook;
  final AppliedOffer? offer;

  @override
  State<DoctorProfileBody> createState() => _DoctorProfileBodyState();
}

class _DoctorProfileBodyState extends State<DoctorProfileBody> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    final doctor = widget.doctor;
    final offer = widget.offer;
    final description = doctor.description?.trim();
    final showOffer = offer != null && offer.hasClientDiscount;

    return Stack(
      children: [
        ListView(
          padding: EdgeInsets.only(top: 8.h, bottom: 104.h),
          children: [
            DoctorHeroHeader(doctor: doctor),
            16.height,
            DoctorProfileStats(doctor: doctor, offer: offer),
            if (doctor.nearestAvailable != null) ...[
              10.height,
              DoctorNearestSlotBanner(doctor: doctor),
            ],
            if (showOffer) ...[
              12.height,
              const DoctorOfferBanner(),
            ],
            if (description != null && description.isNotEmpty) ...[
              14.height,
              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(LocaleKeys.booking_about.tr(),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                    8.height,
                    AppText(description,
                        fontSize: 12,
                        color: AppColors.textSecondaryColor.themeColor,
                        height: 1.8),
                  ],
                ),
              ),
            ],
            16.height,
            DoctorSpecializationsSection(doctor: doctor),
            _ProfileTabs(index: _tab, onChanged: (i) => setState(() => _tab = i)),
            16.height,
            if (_tab == 0)
              ..._clinicsTab()
            else
              DoctorReviewsTab(doctorId: doctor.id, avgRate: doctor.avgRate),
          ],
        ),
        Positioned(
          bottom: 8.h,
          left: 0,
          right: 0,
          child: DoctorBookBar(
            doctor: doctor,
            offer: offer,
            onBook: () => widget.onBook(null),
          ),
        ),
      ],
    );
  }

  List<Widget> _clinicsTab() {
    final clinics = widget.doctor.clinics;
    if (clinics.isEmpty) {
      return [
        AppCard(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 18.h),
            child: Center(
              child: AppText(LocaleKeys.booking_noClinics.tr(),
                  fontSize: 12,
                  color: AppColors.mutedColor.themeColor,
                  textAlign: TextAlign.center),
            ),
          ),
        ),
      ];
    }
    return [
      for (final clinic in clinics)
        DoctorClinicCard(clinic: clinic, onBook: () => widget.onBook(clinic.id)),
    ];
  }
}

class _ProfileTabs extends StatelessWidget {
  const _ProfileTabs({required this.index, required this.onChanged});

  final int index;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(4.r),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.themeColor,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Expanded(child: _segment(0, LocaleKeys.booking_clinics.tr())),
          Expanded(child: _segment(1, LocaleKeys.booking_reviewsTab.tr())),
        ],
      ),
    );
  }

  Widget _segment(int i, String label) {
    final active = index == i;
    return GestureDetector(
      onTap: () => onChanged(i),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: active ? AppColors.cardColor.themeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(11.r),
          boxShadow: active
              ? [
                  BoxShadow(
                    color: AppColors.textPrimaryColor.themeColor.withValues(alpha: 0.06),
                    blurRadius: 6,
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12.5.sp,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
            color: active
                ? AppColors.textPrimaryColor.themeColor
                : AppColors.mutedColor.themeColor,
          ),
        ),
      ),
    );
  }
}
