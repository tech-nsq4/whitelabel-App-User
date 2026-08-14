import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Search-by-name field above the doctors list on [SpecsScreen] — built on
/// the shared [CustomTextField] instead of a bespoke `TextField` so it gets
/// the app's standard RTL-correct spacing/borders for free.
class DoctorSearchBar extends StatelessWidget {
  const DoctorSearchBar({super.key, required this.controller, required this.onChanged});

  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      onChanged: onChanged,
      hint: LocaleKeys.booking_searchDoctorHint.tr(),
      prefixIcon: Icon(Icons.search_rounded, color: AppColors.mutedColor.themeColor, size: 20.sp),
      fillColor:Colors.white,
      borderColor: AppColors.dividerColor.themeColor,
      borderRadius: 14.r,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    );
  }
}
