import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text_field.dart';

/// Debounced search-by-name field used across the booking flow — the doctors
/// list on [SpecsScreen]/`DoctorSearchScreen` and the specialties list on
/// [SpecsScreen]. Built on the shared [CustomTextField] so it inherits the
/// app's RTL-correct spacing/borders.
class SearchBarField extends StatelessWidget {
  const SearchBarField({
    super.key,
    required this.controller,
    required this.onChanged,
    required this.hint,
  });

  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hint;

  @override
  Widget build(BuildContext context) {
    return CustomTextField(
      controller: controller,
      onChanged: onChanged,
      hint: hint,
      prefixIcon: Icon(Icons.search_rounded, color: AppColors.mutedColor.themeColor, size: 20.sp),
      fillColor: Colors.white,
      borderColor: AppColors.dividerColor.themeColor,
      borderRadius: 14.r,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
    );
  }
}
