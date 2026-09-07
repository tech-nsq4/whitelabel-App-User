import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/price_text.dart';
import '../../../offers/data/models/applied_offer.dart';
import '../../data/models/doctor_profile_model.dart';

/// The floating fee + "book" CTA pinned to the bottom of [DoctorScreen].
/// [onBook] runs the shared booking flow with no clinic pre-selected — the
/// slot sheet picks the clinic when the doctor has more than one.
class DoctorBookBar extends StatelessWidget {
  const DoctorBookBar({super.key, required this.doctor, required this.onBook, this.offer});

  final DoctorProfileModel doctor;
  final VoidCallback onBook;
  final AppliedOffer? offer;

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
              PriceText(
                amount: offer?.finalPriceFor(doctor.price) ?? doctor.price,
                strikeAmount: doctor.price,
                isHeading: true,
                fontSize: 15,
                color: AppColors.primaryColor.themeColor,
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
