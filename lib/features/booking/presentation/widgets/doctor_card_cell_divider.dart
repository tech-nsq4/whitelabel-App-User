import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class DoctorCardCellDivider extends StatelessWidget {
  const DoctorCardCellDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 2,
      height: 50.h,
      color: AppColors.dividerColor.themeColor,
    );
  }
}
