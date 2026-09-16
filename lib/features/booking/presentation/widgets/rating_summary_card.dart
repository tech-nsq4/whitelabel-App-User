import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';

class RatingSummaryCard extends StatelessWidget {
  const RatingSummaryCard({super.key, required this.rate, this.comment});

  final int rate;
  final String? comment;

  @override
  Widget build(BuildContext context) {
    final gold = AppColors.accentGold.themeColor;
    final hasComment = comment != null && comment!.isNotEmpty;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48.r,
                height: 48.r,
                decoration: BoxDecoration(
                  color: gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(15.r),
                ),
                alignment: Alignment.center,
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: '$rate',
                        style: TextStyle(
                          fontFamily: AppFonts.headingFont,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                          color: gold,
                        ),
                      ),
                      TextSpan(
                        text: '/5',
                        style: TextStyle(
                          fontFamily: AppFonts.headingFont,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w600,
                          color: gold.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              12.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        for (var i = 1; i <= 5; i++)
                          Padding(
                            padding: EdgeInsetsDirectional.only(end: 2.w),
                            child: Icon(
                              i <= rate ? Icons.star_rounded : Icons.star_border_rounded,
                              color: gold,
                              size: 19.sp,
                            ),
                          ),
                      ],
                    ),
                    5.height,
                    AppText(
                      _ratingLabel(),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mutedColor.themeColor,
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (hasComment) ...[
            14.height,
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(12.r),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor.themeColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.format_quote_rounded, size: 16.sp, color: AppColors.hintColor.themeColor),
                  8.width,
                  Expanded(
                    child: AppText(
                      comment!,
                      fontSize: 13,
                      color: AppColors.textSecondaryColor.themeColor,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _ratingLabel() {
    switch (rate) {
      case 5:
        return LocaleKeys.booking_rateExcellent.tr();
      case 4:
        return LocaleKeys.booking_rateVeryGood.tr();
      case 3:
        return LocaleKeys.booking_rateGood.tr();
      case 2:
        return LocaleKeys.booking_rateFair.tr();
      default:
        return LocaleKeys.booking_ratePoor.tr();
    }
  }
}
