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
import '../../../../core/widgets/image/custom_image.dart';
import '../../../../core/widgets/price_text.dart';
import '../../../../core/widgets/star_rating.dart';
import '../../../offers/data/models/applied_offer.dart';
import '../../data/models/doctor_profile_model.dart';
import '../booking_flow.dart';
import 'booking_slots_sheet.dart' show formatNearestAvailableDayLabel;

/// A doctor result card on [SpecsScreen] / `DoctorSearchScreen` — avatar and
/// summary on top, then a stat strip (experience / fee / next open slot) and
/// book / profile actions. Rating shows as stars beside the name, not in the
/// strip.
class DoctorCard extends StatelessWidget {
  const DoctorCard({super.key, required this.doctor, required this.onTap, this.offer});

  final DoctorProfileModel doctor;
  final VoidCallback onTap;
  final AppliedOffer? offer;

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
    final finalPrice = offer?.finalPriceFor(doctor.price) ?? doctor.price;

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
                        child: Text(doctor.avatarLetter,
                            style: TextStyle(
                                fontFamily: AppFonts.headingFont,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w600,
                                color: Colors.white)),
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
                                Text(avgRate.toStringAsFixed(1),
                                    style: TextStyle(
                                        fontSize: 11.sp,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimaryColor.themeColor)),
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

                  child: _StatCell(
                    value: LocaleKeys.booking_yearsValue
                        .tr(namedArgs: {'years': '${doctor.experienceYears}'}),
                    label: LocaleKeys.booking_experienceLabel.tr(),
                  ),
                ),
                _CellDivider(),
                Expanded(
                  flex: 2,
                  child: _StatCell(
                    valueWidget: PriceText(
                      amount: finalPrice,
                      strikeAmount: doctor.price,
                      isHeading: true,
                      fontSize: 10,
                      maxLines: 2,
                      strikeFontSize: 9.5,
                      color: primary,
                      textAlign: TextAlign.center,
                    ),
                    label: LocaleKeys.booking_feeLabel.tr(),
                  ),
                ),
                _CellDivider(),
                Expanded(
                  flex: 3,
                  child: _StatCell(
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
                    onTap: () => bookDoctorById(context, doctorId: doctor.id, offer: offer),
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

class _StatCell extends StatelessWidget {
  const _StatCell({this.value, this.valueWidget, required this.label, this.valueColor});

  final String? value;
  final Widget? valueWidget;
  final String label;
  final Color? valueColor;

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
                fontSize: 9.sp,
                fontWeight: FontWeight.w700,
                color: valueColor ?? AppColors.textPrimaryColor.themeColor,
              ),
            ),
        3.height,
        AppText(
          label,
          fontSize: 9.5,
          color: AppColors.mutedColor.themeColor,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}

class _CellDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: 50.h,
      color: AppColors.dividerColor.themeColor,
    );
  }
}
