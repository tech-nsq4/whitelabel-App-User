import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/price_text.dart';
import '../../data/models/home_visit_area_model.dart';

class HomeVisitAreasWrap extends StatelessWidget {
  const HomeVisitAreasWrap({super.key, required this.areas, this.highlightedAreaId});

  final List<HomeVisitAreaModel> areas;
  final int? highlightedAreaId;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Wrap(
      spacing: 6.w,
      runSpacing: 6.h,
      children: [
        for (final area in areas)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: area.id == highlightedAreaId
                  ? primary.withValues(alpha: 0.1)
                  : AppColors.surfaceColor.themeColor,
              borderRadius: BorderRadius.circular(99.r),
              border: Border.all(
                color: area.id == highlightedAreaId ? primary : AppColors.dividerColor.themeColor,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.location_on_rounded, size: 11.sp, color: primary),
                4.width,
                AppText(area.name,
                    fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.textSecondaryColor.themeColor),
                if (area.hasCost) ...[
                  5.width,
                  PriceText(amount: area.costValue, fontSize: 10, color: primary),
                ],
              ],
            ),
          ),
      ],
    );
  }
}
