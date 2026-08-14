import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';

/// Filter chips shown under [DoctorSearchBar]. Only [DoctorFilter.nearest]
/// is backed by a real query (`lat`/`lng`, from the device's location) —
/// [consultant]/[topRated] are kept for visual parity with the design but
/// don't affect the fetched list yet, since `/doctors` has no rating or
/// "consultant" field to filter by.
enum DoctorFilter { consultant, topRated, nearest }

class DoctorFilterChips extends StatelessWidget {
  const DoctorFilterChips({super.key, required this.selected, required this.onSelect});

  final DoctorFilter? selected;
  final ValueChanged<DoctorFilter> onSelect;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Wrap(
          spacing: 8.w,
          runSpacing: 5.h,
          children: [
            _FilterChip(
              label: LocaleKeys.booking_filterConsultant.tr(),
              isSelected: selected == DoctorFilter.consultant,
              onTap: () => onSelect(DoctorFilter.consultant),
            ),
            _FilterChip(
              label: LocaleKeys.booking_filterTopRated.tr(),
              isSelected: selected == DoctorFilter.topRated,
              onTap: () => onSelect(DoctorFilter.topRated),
            ),
            _FilterChip(
              label: LocaleKeys.booking_filterNearest.tr(),
              isSelected: selected == DoctorFilter.nearest,
              onTap: () => onSelect(DoctorFilter.nearest),
            ),
          ],
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.isSelected, required this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: isSelected ? primary : AppColors.cardColor.themeColor,
          border: Border.all(color: isSelected ? Colors.transparent : AppColors.dividerColor.themeColor),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 11.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondaryColor.themeColor)),
      ),
    );
  }
}
