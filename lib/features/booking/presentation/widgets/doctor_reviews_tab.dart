import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/star_rating.dart';

typedef _Review = ({String name, String date, double rating, String comment});

/// Placeholder patient-reviews view for [DoctorScreen]'s "reviews" tab — no
/// endpoint backs it yet, so the list is mock content and "view all" is a
/// no-op toast.
class DoctorReviewsTab extends StatelessWidget {
  const DoctorReviewsTab({super.key, this.avgRate});

  final double? avgRate;

  static const int _totalCount = 412;

  static const List<_Review> _reviews = [
    (
      name: 'محمد ص.',
      date: '3 أغسطس 2026',
      rating: 5,
      comment: 'الدكتور شاطر وهادئ وتشخيصه دقيق ومريح في التعامل.',
    ),
    (
      name: 'نورة ع.',
      date: '21 يوليو 2026',
      rating: 5,
      comment: 'شرح لي حالتي بالتفصيل وأعطاني وقتًا كافيًا. أنصح به.',
    ),
    (
      name: 'عبدالله ح.',
      date: '13 يوليو 2026',
      rating: 4,
      comment: 'كشف ممتاز، لكن الانتظار كان أطول من المتوقع بقليل.',
    ),
    (
      name: 'سارة م.',
      date: '2 يوليو 2026',
      rating: 5,
      comment: 'متابعة رائعة وردّ سريع على الاستفسارات بعد الزيارة.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final rate = avgRate ?? 4.8;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        AppCard(
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(rate.toStringAsFixed(1),
                      style: TextStyle(
                        fontFamily: AppFonts.headingFont,
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryColor.themeColor,
                      )),
                  3.height,
                  StarRating(value: rate, size: 12, spacing: 1.5),
                ],
              ),
              16.width,
              Container(width: 1, height: 40.h, color: AppColors.dividerColor.themeColor),
              16.width,
              Expanded(
                child: AppText(
                  LocaleKeys.booking_overallRatingFrom.tr(namedArgs: {'count': '$_totalCount'}),
                  fontSize: 11.5,
                  color: AppColors.textSecondaryColor.themeColor,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
        14.height,
        for (final review in _reviews) ...[
          _ReviewCard(review),
          10.height,
        ],
        4.height,
        CustomButton(
          title: LocaleKeys.booking_viewAllReviews.tr(namedArgs: {'count': '$_totalCount'}),
          isOutlined: true,
          onTap: () => AppOverlay.showSuccess(LocaleKeys.home_comingSoon.tr()),
        ),
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard(this.review);

  final _Review review;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StarRating(value: review.rating, size: 12, spacing: 1.5),
          8.height,
          AppText('"${review.comment}"',
              fontSize: 12,
              color: AppColors.textPrimaryColor.themeColor,
              height: 1.7),
          8.height,
          AppText('${review.name} · ${review.date}',
              fontSize: 10.5, color: AppColors.mutedColor.themeColor),
        ],
      ),
    );
  }
}
