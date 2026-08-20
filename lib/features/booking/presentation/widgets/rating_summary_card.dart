import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';

/// Read-only recap of an already-submitted rating (`AppointmentModel.rate`/
/// `.comment`) on `AppointmentDetailScreen` — shown instead of the "rate"
/// action once [AppointmentModel.isRated] is true, so a completed booking
/// doesn't just quietly drop the button with no acknowledgement.
class RatingSummaryCard extends StatelessWidget {
  const RatingSummaryCard({super.key, required this.rate, this.comment});

  final int rate;
  final String? comment;

  @override
  Widget build(BuildContext context) {
    final gold = AppColors.accentGold.themeColor;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for (var i = 1; i <= 5; i++)
                Icon(
                  i <= rate ? Icons.star_rounded : Icons.star_border_rounded,
                  color: gold,
                  size: 20.sp,
                ),
            ],
          ),
          if (comment != null && comment!.isNotEmpty) ...[
            8.height,
            AppText(comment!, fontSize: 12, color: AppColors.textSecondaryColor.themeColor, height: 1.6),
          ],
        ],
      ),
    );
  }
}
