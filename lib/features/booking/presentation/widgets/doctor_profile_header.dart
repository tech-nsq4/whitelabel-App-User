import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../../core/widgets/star_rating.dart';
import '../../../../core/widgets/image/custom_image.dart';
import '../../../offers/data/models/applied_offer.dart';
import '../../data/models/doctor_profile_model.dart';
import 'booking_slots_sheet.dart' show formatNearestAvailableDayLabel;
import 'doctor_stats_strip.dart';

class DoctorProfileHeader extends StatelessWidget {
  const DoctorProfileHeader({
    super.key,
    required this.doctor,
    this.onChatTap,
    this.offer,
    this.paidPrice,
  });

  final DoctorProfileModel doctor;
  final VoidCallback? onChatTap;
  final AppliedOffer? offer;
  final double? paidPrice;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final hasImage = doctor.image != null && doctor.image!.isNotEmpty;
    final nearestAvailable = doctor.nearestAvailable;

    return AppCard(
      margin: EdgeInsets.only(bottom: 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(22.r),
                  border: Border.all(color: AppColors.dividerColor.themeColor),
                ),
                padding: EdgeInsets.all(3.r),
                child: hasImage
                    ? CustomImage(image: doctor.image!, width: 62.r, height: 62.r, radius: 18.r)
                    : Container(
                        width: 62.r,
                        height: 62.r,
                        decoration: BoxDecoration(
                          color: primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(18.r),
                        ),
                        alignment: Alignment.center,
                        child: Text(doctor.avatarLetter,
                            style: TextStyle(
                                fontFamily: AppFonts.headingFont,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                                color: primary)),
                      ),
              ),
              13.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(doctor.name,
                        isHeading: true,
                        fontSize: 16.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryColor.themeColor),
                    if (doctor.specialtyLabel.isNotEmpty) ...[
                      5.height,
                      AppText(doctor.specialtyLabel,
                          fontSize: 12, fontWeight: FontWeight.w600, color: primary, maxLines: 2),
                    ],
                    if (doctor.avgRate != null) ...[
                      6.height,
                      Row(
                        children: [
                          StarRating(value: doctor.avgRate!, size: 13, spacing: 1.5),
                          5.width,
                          AppText(doctor.avgRate!.toStringAsFixed(1),
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimaryColor.themeColor),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              if (onChatTap != null) ...[
                8.width,
                CustomTapEffect(
                  onTap: onChatTap!,
                  child: Container(
                    width: 38.r,
                    height: 38.r,
                    decoration: BoxDecoration(
                      color: primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(13.r),
                    ),
                    child: Center(child: AppSvgIcon(AppSvgIcons.chatBubble, size: 18.sp, color: primary)),
                  ),
                ),
              ],
            ],
          ),
          14.height,
          DoctorStatsStrip(doctor: doctor, offer: offer, paidPrice: paidPrice),
          if (nearestAvailable != null) ...[
            12.height,
            _NearestAvailableBanner(nearestAvailable),
          ],
        ],
      ),
    );
  }
}

class _NearestAvailableBanner extends StatelessWidget {
  const _NearestAvailableBanner(this.nearestAvailable);

  final DoctorNearestAvailableModel nearestAvailable;

  @override
  Widget build(BuildContext context) {
    final success = AppColors.successColor.themeColor;
    final when = nearestAvailable.date == null
        ? ''
        : formatNearestAvailableDayLabel(nearestAvailable.date!, context.locale.languageCode);
    final value = [when, nearestAvailable.displayTime].where((s) => s.isNotEmpty).join(' · ');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: success.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Container(
            width: 26.r,
            height: 26.r,
            decoration: BoxDecoration(color: success.withValues(alpha: 0.15), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Icon(Icons.event_available_rounded, size: 14.sp, color: success),
          ),
          10.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(LocaleKeys.booking_nearestAvailableLabel.tr(),
                    fontSize: 9.5, color: AppColors.mutedColor.themeColor),
                2.height,
                AppText(value,
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: success,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
