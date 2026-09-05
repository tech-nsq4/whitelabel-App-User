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
import '../../data/models/offer_model.dart';

class OfferCard extends StatelessWidget {
  const OfferCard({super.key, required this.offer, required this.onBook});

  final OfferModel offer;
  final VoidCallback onBook;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final locale = context.locale.languageCode;
    final cover = offer.cover;

    return AppCard(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(16.r),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (cover != null && cover.isNotEmpty) ...[
            CustomImage(image: cover, height: 120.h, radius: 14.r),
            12.height,
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _DiscountValue(offer: offer, color: primary),
              const Spacer(),
              _ExpiryBadge(offer: offer, locale: locale),
            ],
          ),
          10.height,
          AppText(
            offer.name,
            isHeading: true,
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryColor.themeColor,
          ),
          if ((offer.description ?? '').isNotEmpty) ...[
            4.height,
            AppText(
              offer.description!,
              fontSize: 11.5,
              color: AppColors.mutedColor.themeColor,
              height: 1.5,
            ),
          ],
          14.height,
          CustomButton(
            title: offer.isPercentage
                ? LocaleKeys.offers_bookWithDiscount.tr()
                : LocaleKeys.offers_bookNow.tr(),
            height: 42,
            radius: 13,
            onTap: onBook,
          ),
        ],
      ),
    );
  }
}

class _DiscountValue extends StatelessWidget {
  const _DiscountValue({required this.offer, required this.color});

  final OfferModel offer;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final discountValue = offer.discountValue;
    final isWhole = discountValue.truncateToDouble() == discountValue;
    final value = discountValue.toStringAsFixed(isWhole ? 0 : 2);

    if (offer.isPercentage) {
      return AppText(
        '$value%',
        isHeading: true,
        fontSize: 24,
        fontWeight: FontWeight.w800,
        color: color,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          value,
          isHeading: true,
          fontSize: 22,
          fontWeight: FontWeight.w800,
          color: color,
        ),
        AppText(
          LocaleKeys.common_currency.tr(),
          fontSize: 10.5,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ],
    );
  }
}

class _ExpiryBadge extends StatelessWidget {
  const _ExpiryBadge({required this.offer, required this.locale});

  final OfferModel offer;
  final String locale;

  @override
  Widget build(BuildContext context) {
    final endsAt = offer.endsAt;
    final label = offer.isPermanent || endsAt == null
        ? LocaleKeys.offers_permanent.tr()
        : LocaleKeys.offers_endsOn.tr(namedArgs: {'date': DateFormat('d MMMM', locale).format(endsAt)});

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.themeColor,
        borderRadius: BorderRadius.circular(99),
      ),
      child: AppText(
        label,
        fontSize: 10,
        fontWeight: FontWeight.w600,
        color: AppColors.mutedColor.themeColor,
      ),
    );
  }
}
