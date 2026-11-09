import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../../core/widgets/price_text.dart';

class HomeVisitChoiceChip extends StatelessWidget {
  const HomeVisitChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.trailing,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final double? trailing;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final cost = trailing;

    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: selected ? primary : AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(99.r),
          border: Border.all(color: selected ? primary : AppColors.dividerColor.themeColor),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              selected ? Icons.check_circle_rounded : Icons.location_on_rounded,
              size: 14.sp,
              color: selected ? Colors.white : primary,
            ),
            6.width,
            AppText(
              label,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : AppColors.textSecondaryColor.themeColor,
            ),
            if (cost != null) ...[
              6.width,
              PriceText(
                amount: cost,
                fontSize: 10.5,
                color: selected ? Colors.white : primary,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
