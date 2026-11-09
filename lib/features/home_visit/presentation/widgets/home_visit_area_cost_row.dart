import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/price_text.dart';
import '../../data/models/home_visit_area_model.dart';

class HomeVisitAreaCostRow extends StatelessWidget {
  const HomeVisitAreaCostRow({super.key, required this.area, this.highlighted = false});

  final HomeVisitAreaModel area;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Container(
      margin: EdgeInsets.only(bottom: 6.h),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: highlighted ? primary.withValues(alpha: 0.08) : AppColors.surfaceColor.themeColor,
        borderRadius: BorderRadius.circular(10.r),
        border: highlighted ? Border.all(color: primary) : null,
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_rounded, size: 14.sp, color: primary),
          6.width,
          Expanded(
            child: AppText(area.name,
                fontSize: 11.5,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryColor.themeColor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
          ),
          if (area.hasCost) PriceText(amount: area.costValue, fontSize: 11.5, color: primary),
        ],
      ),
    );
  }
}
