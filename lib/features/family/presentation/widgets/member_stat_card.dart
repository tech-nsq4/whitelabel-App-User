import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_text.dart';

/// Small value/label stat tile on [MemberScreen] (age, medical-files count…).
class MemberStatCard extends StatelessWidget {
  const MemberStatCard({super.key, required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontFamily: AppFonts.headingFont,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor.themeColor)),
          AppText(label, fontSize: 9, color: AppColors.mutedColor.themeColor),
        ],
      ),
    );
  }
}
