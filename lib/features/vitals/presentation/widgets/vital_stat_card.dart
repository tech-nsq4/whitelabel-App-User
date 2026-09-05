import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';

class VitalStatCard extends StatelessWidget {
  const VitalStatCard({super.key, required this.label, required this.value, required this.unit});

  final String label;
  final String value;
  final String unit;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(label, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
          6.height,
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value,
                  style: TextStyle(
                      fontFamily: AppFonts.headingFont,
                      fontSize: 22.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimaryColor.themeColor)),
              4.width,
              AppText(unit, fontSize: 10, color: AppColors.mutedColor.themeColor),
            ],
          ),
        ],
      ),
    );
  }
}
