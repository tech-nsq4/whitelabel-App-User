import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../data/models/doctor_profile_model.dart';

class DoctorClinicSelector extends StatelessWidget {
  const DoctorClinicSelector({
    super.key,
    required this.clinics,
    required this.selectedId,
    required this.onSelect,
  });

  final List<DoctorClinicModel> clinics;
  final int? selectedId;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.w,
      runSpacing: 8.h,
      children: [
        for (final clinic in clinics) _ClinicChip(
          name: clinic.name,
          selected: clinic.id == selectedId,
          onTap: () => onSelect(clinic.id),
        ),
      ],
    );
  }
}

class _ClinicChip extends StatelessWidget {
  const _ClinicChip({required this.name, required this.selected, required this.onTap});

  final String name;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: selected ? primary : AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(99),
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
            Text(
              name,
              style: TextStyle(
                fontSize: 11.5.sp,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.textSecondaryColor.themeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
