import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';

enum DoctorSort {
  closestAvailable('closest_available', LocaleKeys.booking_sortClosestAvailable),
  nearestDistance('closest_available', LocaleKeys.booking_sortNearestDistance),
  highestRated('highest_rated', LocaleKeys.booking_sortHighestRated),
  lowestPrice('lowest_price', LocaleKeys.booking_sortLowestPrice);

  const DoctorSort(this.value, this.labelKey);

  final String value;
  final String labelKey;

  bool get needsLocation => this == DoctorSort.nearestDistance;
}

class DoctorFilterChips extends StatelessWidget {
  const DoctorFilterChips({super.key, required this.selected, required this.onSelect});

  final DoctorSort? selected;
  final ValueChanged<DoctorSort> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: EdgeInsetsDirectional.only(end: 12.w),
      child: Row(
        children: [
          for (final sort in DoctorSort.values)
            Padding(
              padding: EdgeInsetsDirectional.only(end: 8.w),
              child: _FilterChip(
                label: sort.labelKey.tr(),
                isSelected: selected == sort,
                onTap: () => onSelect(sort),
              ),
            ),
        ],
      ),
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
