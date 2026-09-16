import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/star_rating.dart';
import '../../data/models/doctor_review_model.dart';

class DoctorReviewCard extends StatelessWidget {
  const DoctorReviewCard({super.key, required this.review});

  final DoctorReviewModel review;

  @override
  Widget build(BuildContext context) {
    final comment = review.comment;
    final date = review.displayDate;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AppText(
                  review.userName,
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor.themeColor,
                ),
              ),
              8.width,
              StarRating(value: review.rate.toDouble(), size: 12, spacing: 1.5),
            ],
          ),
          if (comment != null && comment.isNotEmpty) ...[
            8.height,
            AppText('"$comment"',
                fontSize: 12,
                color: AppColors.textPrimaryColor.themeColor,
                height: 1.7),
          ],
          if (date.isNotEmpty) ...[
            8.height,
            AppText(date, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
          ],
        ],
      ),
    );
  }
}
