import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/price_text.dart';
import '../../../booking/data/models/appointment_quote_model.dart';

class PromoQuoteCard extends StatelessWidget {
  const PromoQuoteCard({super.key, required this.quote});

  final AppointmentQuoteModel quote;

  @override
  Widget build(BuildContext context) {
    final success = AppColors.successColor.themeColor;
    final gold = AppColors.accentGold.themeColor;
    final percent = quote.discountPercent;
    final code = quote.promoCode ?? '';

    final subtitle = code.isEmpty
        ? LocaleKeys.booking_discountPromoLabel.tr()
        : '${LocaleKeys.booking_discountPromoLabel.tr()} · $code';

    final badgeText = percent != null && percent > 0
        ? '−$percent%'
        : LocaleKeys.booking_discountSavedBadge
            .tr(namedArgs: {'amount': formatPriceLabel(quote.discountAmount)});

    return Container(
      padding: EdgeInsets.all(14.r),
      decoration: BoxDecoration(
        color: success.withValues(alpha: 0.07),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: success.withValues(alpha: 0.30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38.r,
                height: 38.r,
                decoration: BoxDecoration(
                  color: success.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.sell_rounded, size: 18.sp, color: success),
              ),
              10.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      LocaleKeys.booking_discountAppliedTitle.tr(),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryColor.themeColor,
                    ),
                    2.height,
                    AppText(
                      subtitle,
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mutedColor.themeColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              8.width,
              Container(
                padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
                decoration: BoxDecoration(
                  color: success.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(9.r),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontFamily: AppFonts.headingFont,
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: success,
                  ),
                ),
              ),
            ],
          ),
          12.height,
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.cardColor.themeColor,
              borderRadius: BorderRadius.circular(11.r),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      formatPriceLabel(quote.originalPrice),
                      style: TextStyle(
                        fontFamily: AppFonts.headingFont,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.mutedColor.themeColor,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    12.width,
                    Text(
                      formatPriceLabel(quote.finalPrice),
                      style: TextStyle(
                        fontFamily: AppFonts.headingFont,
                        fontSize: 17.sp,
                        fontWeight: FontWeight.w800,
                        color: gold,
                      ),
                    ),
                  ],
                ),
                10.height,
                Divider(height: 1, color: AppColors.dividerColor.themeColor),
                10.height,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    AppText(
                      LocaleKeys.booking_discountValueLabel.tr(),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w500,
                      color: AppColors.mutedColor.themeColor,
                    ),
                    Text(
                      '− ${formatPriceLabel(quote.discountAmount)}',
                      style: TextStyle(
                        fontFamily: AppFonts.headingFont,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        color: success,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
