import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/star_rating.dart';

class DoctorRatingSummary extends StatelessWidget {
  const DoctorRatingSummary({super.key, required this.rate, required this.reviewsCount});

  final double rate;
  final int reviewsCount;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Column(
            children: [
              Text(
                rate.toStringAsFixed(1),
                style: TextStyle(
                  fontFamily: AppFonts.headingFont,
                  fontSize: 26.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimaryColor.themeColor,
                ),
              ),
              3.height,
              StarRating(value: rate, size: 12, spacing: 1.5),
            ],
          ),
          16.width,
          Container(width: 1, height: 40.h, color: AppColors.dividerColor.themeColor),
          16.width,
          Expanded(
            child: AppText(
              reviewsCount == 0
                  ? LocaleKeys.booking_reviewsTitle.tr()
                  : LocaleKeys.booking_overallRatingFrom.tr(namedArgs: {'count': '$reviewsCount'}),
              fontSize: 11.5,
              color: AppColors.textSecondaryColor.themeColor,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
