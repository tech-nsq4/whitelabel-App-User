import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/price_text.dart';
import '../../data/models/appointment_model.dart';

class AppointmentDiscountCard extends StatelessWidget {
  const AppointmentDiscountCard({super.key, required this.appointment});

  final AppointmentModel appointment;

  @override
  Widget build(BuildContext context) {
    final success = AppColors.successColor.themeColor;
    final gold = AppColors.accentGold.themeColor;
    final percent = appointment.discountPercent;
    final original = appointment.originalPrice;
    final discount = appointment.discountAmount;
    final total = appointment.finalPrice;

    final sourceLabel = appointment.isPromoDiscount
        ? LocaleKeys.booking_discountPromoLabel.tr()
        : LocaleKeys.booking_discountOfferLabel.tr();
    final promoCode = appointment.promoCode ?? '';
    final subtitle = appointment.isPromoDiscount && promoCode.isNotEmpty
        ? '$sourceLabel · $promoCode'
        : sourceLabel;

    final badgeText = percent != null
        ? '−$percent%'
        : discount != null
            ? LocaleKeys.booking_discountSavedBadge.tr(namedArgs: {'amount': formatPriceLabel(discount)})
            : null;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: success.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(13.r),
                ),
                alignment: Alignment.center,
                child: Icon(Icons.sell_rounded, size: 19.sp, color: success),
              ),
              10.width,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppText(
                      LocaleKeys.booking_discountAppliedTitle.tr(),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimaryColor.themeColor,
                    ),
                    2.height,
                    AppText(
                      subtitle,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.mutedColor.themeColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (badgeText != null) ...[
                8.width,
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
                  decoration: BoxDecoration(
                    color: success.withValues(alpha: 0.14),
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
            ],
          ),
          14.height,
          Container(
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: AppColors.surfaceColor.themeColor,
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Column(
              children: [
                if (original != null)
                  _row(
                    LocaleKeys.booking_discountOriginalPrice.tr(),
                    formatPriceLabel(original),
                    strike: true,
                  ),
                if (discount != null) ...[
                  6.height,
                  _row(
                    LocaleKeys.booking_discountValueLabel.tr(),
                    '− ${formatPriceLabel(discount)}',
                    valueColor: success,
                  ),
                ],
                if (total != null) ...[
                  10.height,
                  Divider(height: 1, color: AppColors.dividerColor.themeColor),
                  10.height,
                  _row(
                    LocaleKeys.booking_discountTotalAfter.tr(),
                    formatPriceLabel(total),
                    valueColor: gold,
                    emphasize: true,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(
    String label,
    String value, {
    bool strike = false,
    Color? valueColor,
    bool emphasize = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
          fontSize: emphasize ? 12.5 : 11.5,
          fontWeight: emphasize ? FontWeight.w700 : FontWeight.w500,
          color: emphasize
              ? AppColors.textPrimaryColor.themeColor
              : AppColors.mutedColor.themeColor,
        ),
        Text(
          value,
          style: TextStyle(
            fontFamily: AppFonts.headingFont,
            fontSize: (emphasize ? 13.5 : 11.5).sp,
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColors.textPrimaryColor.themeColor,
            decoration: strike ? TextDecoration.lineThrough : null,
          ),
        ),
      ],
    );
  }
}
