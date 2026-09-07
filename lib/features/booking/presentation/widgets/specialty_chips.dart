import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

/// One pill in a [SpecialtyChips] row. [id] is `null` for the catch-all
/// "الكل" entry on the sub-specialty row.
class SpecialtyChipItem {
  const SpecialtyChipItem({required this.id, required this.label});

  final int? id;
  final String label;
}

/// The two chip rows on [SpecsScreen] use distinct looks: [primary] for
/// switching the active specialty (solid pill), [secondary] for filtering its
/// sub-specialties (smaller, tinted).
enum SpecialtyChipStyle { primary, secondary }

/// Horizontally-scrolling pill row used on [SpecsScreen] to switch the active
/// specialty and to filter its sub-specialties without leaving the doctors
/// list.
class SpecialtyChips extends StatelessWidget {
  const SpecialtyChips({
    super.key,
    required this.items,
    required this.selectedId,
    required this.onSelect,
    this.style = SpecialtyChipStyle.primary,
    this.padding,
  });

  final List<SpecialtyChipItem> items;
  final int? selectedId;
  final ValueChanged<int?> onSelect;
  final SpecialtyChipStyle style;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final gap = style == SpecialtyChipStyle.secondary ? 6.w : 8.w;

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: padding ?? EdgeInsetsDirectional.only(end: 12.w),
      child: Row(
        children: [
          for (final item in items)
            Padding(
              padding: EdgeInsetsDirectional.only(end: gap),
              child: _Chip(
                label: item.label,
                isSelected: item.id == selectedId,
                style: style,
                onTap: () => onSelect(item.id),
              ),
            ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isSelected,
    required this.style,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final SpecialtyChipStyle style;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final secondary = style == SpecialtyChipStyle.secondary;

    final Color background;
    final Color foreground;
    final Color borderColor;
    if (secondary) {
      background = isSelected
          ? primary.withValues(alpha: 0.1)
          : AppColors.surfaceColor.themeColor;
      foreground = isSelected ? primary : AppColors.mutedColor.themeColor;
      borderColor = isSelected ? primary.withValues(alpha: 0.35) : Colors.transparent;
    } else {
      background = isSelected ? primary : AppColors.cardColor.themeColor;
      foreground = isSelected ? Colors.white : AppColors.textSecondaryColor.themeColor;
      borderColor = isSelected ? Colors.transparent : AppColors.dividerColor.themeColor;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: secondary
            ? EdgeInsets.symmetric(horizontal: 11.w, vertical: 5.h)
            : EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
        decoration: BoxDecoration(
          color: background,
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: secondary ? 10.5.sp : 11.5.sp,
            fontWeight: secondary ? FontWeight.w500 : FontWeight.w600,
            color: foreground,
          ),
        ),
      ),
    );
  }
}
