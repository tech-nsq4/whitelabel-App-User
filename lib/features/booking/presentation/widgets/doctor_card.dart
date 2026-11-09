import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/image/custom_image.dart';
import '../../../../core/widgets/price_text.dart';
import '../../../../core/widgets/star_rating.dart';
import '../../../offers/data/models/applied_offer.dart';
import '../../data/models/consultation_type.dart';
import '../../data/models/doctor_profile_model.dart';
import '../../../home_visit/data/models/home_visit_area_model.dart';
import '../../../home_visit/presentation/widgets/home_visit_areas_wrap.dart';
import '../../../home_visit/presentation/widgets/home_visit_badge.dart';
import '../booking_flow.dart';
import 'booking_slots_sheet.dart' show formatNearestAvailableDayLabel;
import 'doctor_card_cell_divider.dart';
import 'doctor_card_stat_cell.dart';

/// A doctor result card on [SpecsScreen] / `DoctorSearchScreen` — avatar and
/// summary on top, then a stat strip (experience / fee / next open slot) and
/// book / profile actions. Rating shows as stars beside the name, not in the
/// strip.
class DoctorCard extends StatelessWidget {
  const DoctorCard({
    super.key,
    required this.doctor,
    required this.onTap,
    this.offer,
    this.consultationType = ConsultationType.clinic,
    this.homeVisitArea,
  });

  final DoctorProfileModel doctor;
  final VoidCallback onTap;
  final AppliedOffer? offer;
  final ConsultationType consultationType;
  final HomeVisitAreaModel? homeVisitArea;

  HomeVisitAreaModel? get _matchedArea {
    final area = homeVisitArea;
    if (area == null) return null;
    return doctor.homeVisitAreaById(area.id) ?? area;
  }

  double get _basePrice {
    if (!consultationType.isHomeVisit) return doctor.price;
    final matched = _matchedArea;
    if (matched != null && matched.hasCost) return matched.costValue;
    final costs = doctor.homeVisitAreas.where((a) => a.hasCost).map((a) => a.costValue);
    return costs.isEmpty ? doctor.price : costs.reduce((a, b) => a < b ? a : b);
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final hasImage = doctor.image != null && doctor.image!.isNotEmpty;
    final avgRate = doctor.avgRate;
    final description = doctor.description?.trim();
    final nearest = doctor.nearestAvailable;
    final nearestLabel = nearest == null
        ? null
        : [
            if (nearest.date != null)
              formatNearestAvailableDayLabel(nearest.date!, context.locale.languageCode),
            nearest.displayTime,
          ].where((s) => s.isNotEmpty).join(' · ');
    final basePrice = _basePrice;
    final finalPrice = offer?.finalPriceFor(basePrice) ?? basePrice;
    final isHomeVisit = consultationType.isHomeVisit;

    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.zero,
      margin: EdgeInsets.only(bottom: 14.h),
      clipContent: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 12.h),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                hasImage
                    ? CustomImage(image: doctor.image!, width: 50.r, height: 50.r, radius: 16.r)
                    : Container(
                        width: 50.r,
                        height: 50.r,
                        decoration: BoxDecoration(
                          color:AppColors.primaryColor.themeColor,
                          borderRadius: BorderRadius.circular(16.r),
                        ),
                        padding: 10.paddingBottom,
                        alignment: Alignment.center,
                        child: AppText(doctor.avatarLetter,
                            isHeading: true,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: Colors.white),
                      ),
                12.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          AppText(doctor.name,
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimaryColor.themeColor,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis),
                          if (avgRate != null) ...[
                            4.height,
                            Row(
                              children: [
                                StarRating(value: avgRate, size: 12, spacing: 1.5),
                                5.width,
                                AppText(avgRate.toStringAsFixed(1),
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimaryColor.themeColor),
                              ],
                            ),
                          ],
                        ],
                      ),

                      if (doctor.specialtyLabel.isNotEmpty || doctor.experienceYears > 0) ...[
                        2.height,
                        AppText(
                          [
                            if (doctor.specialtyLabel.isNotEmpty) doctor.specialtyLabel,
                            if (doctor.experienceYears > 0)
                              LocaleKeys.booking_experienceYears
                                  .tr(namedArgs: {'years': '${doctor.experienceYears}'}),
                          ].join(' · '),
                          fontSize: 10.5,
                          color: AppColors.mutedColor.themeColor,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                      if (doctor.homeVisit && !isHomeVisit) ...[
                        5.height,
                        const HomeVisitBadge(),
                      ],
                      if (description != null && description.isNotEmpty) ...[
                        5.height,
                        AppText(description,
                            fontSize: 11,
                            color: AppColors.textSecondaryColor.themeColor,
                            height: 1.6,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isHomeVisit && doctor.homeVisitAreas.isNotEmpty)
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(14.w, 0, 14.w, 10.h),
              child: HomeVisitAreasWrap(
                areas: doctor.homeVisitAreas,
                highlightedAreaId: _matchedArea?.id,
              ),
            ),
          Container(
            margin: 14.paddingHorizontal,
            decoration: BoxDecoration(
              color: AppColors.surfaceColor.themeColor,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppColors.dividerColor.themeColor),
            ),
            padding: EdgeInsets.symmetric(vertical: 0.h, horizontal: 0.w),
            child: Row(
              children: [
                Expanded(
                  flex: 2,

                  child: DoctorCardStatCell(
                    value: LocaleKeys.booking_yearsValue
                        .tr(namedArgs: {'years': '${doctor.experienceYears}'}),
                    label: LocaleKeys.booking_experienceLabel.tr(),
                  ),
                ),
                const DoctorCardCellDivider(),
                Expanded(
                  flex: 2,
                  child: DoctorCardStatCell(
                    valueWidget: PriceText(
                      amount: finalPrice,
                      strikeAmount: basePrice,
                      isHeading: true,
                      fontSize: 10,
                      maxLines: 2,
                      strikeFontSize: 9.5,
                      color: primary,
                      textAlign: TextAlign.center,
                    ),
                    label: isHomeVisit
                        ? LocaleKeys.homeVisit_visitCost.tr()
                        : LocaleKeys.booking_feeLabel.tr(),
                  ),
                ),
                const DoctorCardCellDivider(),
                Expanded(
                  flex: 3,
                  child: DoctorCardStatCell(
                    value: nearestLabel == null || nearestLabel.isEmpty ? '—' : nearestLabel,
                    label: LocaleKeys.booking_nextSlot.tr(),
                    valueColor: nearestLabel == null || nearestLabel.isEmpty
                        ? AppColors.mutedColor.themeColor
                        : AppColors.successColor.themeColor,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(12.w, 12.h, 12.w, 12.h),
            child: Row(
              children: [
                Expanded(
                  child: CustomButton(
                    title: LocaleKeys.booking_bookAction.tr(),
                    height: 38,
                    fontSize: 14,
                    onTap: () => bookDoctorById(
                      context,
                      doctorId: doctor.id,
                      offer: offer,
                      consultationType: consultationType,
                      homeVisitArea: _matchedArea,
                    ),
                  ),
                ),
                8.width,
                CustomButton(
                  title: LocaleKeys.booking_profileAction.tr(),
                  isOutlined: true,
                  expanded: false,
                  width: 88.w,
                  textColor: Colors.grey.shade700,
                  height: 38,
                  borderColor: Colors.grey.shade300,
                  fontSize: 12,
                  onTap: onTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
