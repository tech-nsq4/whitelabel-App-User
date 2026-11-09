import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/widgets/app_svg_icon.dart';

class LocationPickerCenterPin extends StatelessWidget {
  const LocationPickerCenterPin({super.key});

  @override
  Widget build(BuildContext context) {
    final size = 46.r;
    return IgnorePointer(
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(bottom: size),
          child: AppSvgIcon(AppSvgIcons.mapPin, size: size, color: AppColors.primaryColor.themeColor),
        ),
      ),
    );
  }
}
