import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/visit_models.dart';

/// Clinic summary row shown on the Visits / lab / x-ray / pharmacy clinic
/// pickers — icon, name, last-visit label, and a visit count badge.
class ClinicSummaryTile extends StatelessWidget {
  const ClinicSummaryTile({
    super.key,
    required this.clinic,
    required this.onTap,
    this.countLabel = 'زيارة',
  });

  final ClinicSummary clinic;
  final VoidCallback onTap;
  final String countLabel;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return AppCard(
      onTap: onTap,
      margin: EdgeInsets.only(bottom: 10.h),
      child: Row(
        children: [
          Container(
            width: 42.r,
            height: 42.r,
            decoration: BoxDecoration(
              color: AppColors.surfaceColor.themeColor,
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Center(
              child: AppSvgIcon(clinic.icon, size: 19.sp, color: primary),
            ),
          ),
          13.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  clinic.name,
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor.themeColor,
                ),
                2.height,
                AppText(
                  clinic.lastVisitLabel,
                  fontSize: 10.5,
                  color: AppColors.mutedColor.themeColor,
                ),
              ],
            ),
          ),
          6.width,
          Column(
            children: [
              Text(
                '${clinic.count}',
                style: TextStyle(
                  fontFamily: AppFonts.headingFont,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: primary,
                ),
              ),
              AppText(
                countLabel,
                fontSize: 9,
                color: AppColors.mutedColor.themeColor,
              ),
            ],
          ),
          8.width,
          AppSvgIcon(
            AppSvgIcons.chevronRow,
            size: 17.sp,
            color: AppColors.hintColor.themeColor,
          ),
        ],
      ),
    );
  }
}
