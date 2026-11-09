import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../home_visit/data/models/home_visit_area_model.dart';
import '../../../home_visit/presentation/widgets/home_visit_areas_card.dart';
import '../../../offers/data/models/applied_offer.dart';
import '../../data/models/consultation_type.dart';
import '../../data/models/doctor_profile_model.dart';
import 'doctor_book_bar.dart';
import 'doctor_clinic_card.dart';
import 'doctor_hero_header.dart';
import 'doctor_nearest_slot_banner.dart';
import 'doctor_offer_banner.dart';
import 'doctor_online_consult_card.dart';
import 'doctor_profile_stats.dart';
import 'doctor_profile_tabs.dart';
import 'doctor_reviews_tab.dart';
import 'doctor_specializations_section.dart';

/// The scrolling body of [DoctorScreen] — the redesigned doctor summary, then
/// a two-tab section (clinics / reviews), with the fee + book CTA pinned to
/// the bottom. [onBook] carries the picked clinic id (`null` from the pinned
/// bar — the slot sheet then picks a clinic when there's more than one).
class DoctorProfileBody extends StatefulWidget {
  const DoctorProfileBody({
    super.key,
    required this.doctor,
    required this.onBook,
    required this.onBookOnline,
    required this.onBookHomeVisit,
    this.offer,
    this.consultationType = ConsultationType.clinic,
    this.homeVisitArea,
  });

  final DoctorProfileModel doctor;
  final void Function(int? clinicId) onBook;
  final VoidCallback onBookOnline;
  final VoidCallback onBookHomeVisit;
  final AppliedOffer? offer;
  final ConsultationType consultationType;
  final HomeVisitAreaModel? homeVisitArea;

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
    final isOnlineFlow = widget.consultationType.isOnline;
    final isHomeVisitFlow = widget.consultationType.isHomeVisit;
    final selectedArea = doctor.homeVisitAreaById(widget.homeVisitArea?.id);

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
            if (doctor.offersHomeVisit) ...[
              12.height,
              HomeVisitAreasCard(
                doctor: doctor,
                highlightedAreaId: selectedArea?.id,
                onBook: isHomeVisitFlow ? null : widget.onBookHomeVisit,
              ),
            ],
            if (doctor.liveAppointment && !isOnlineFlow && !isHomeVisitFlow) ...[
              12.height,
              DoctorOnlineConsultCard(onBook: widget.onBookOnline),
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
            DoctorProfileTabs(index: _tab, onChanged: (i) => setState(() => _tab = i)),
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
            price: isHomeVisitFlow && selectedArea != null && selectedArea.hasCost ? selectedArea.costValue : null,
            priceLabel: isHomeVisitFlow ? LocaleKeys.homeVisit_visitCost.tr() : null,
            onBook: switch (widget.consultationType) {
              ConsultationType.online => widget.onBookOnline,
              ConsultationType.homeVisit => widget.onBookHomeVisit,
              ConsultationType.clinic => () => widget.onBook(null),
            },
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
