import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../data/models/doctor_time_table_model.dart';

/// 4-per-row grid of time-slot chips for [BookingSlotsSheet] — selected
/// (filled), available (outlined, tappable), or unavailable
/// (struck-through, disabled).
class BookingTimeSlotGrid extends StatelessWidget {
  const BookingTimeSlotGrid({super.key, required this.slots, required this.selected, required this.onSelect});

  final List<TimeTableSlotModel> slots;
  final TimeTableSlotModel? selected;
  final ValueChanged<TimeTableSlotModel> onSelect;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 8.h,
      crossAxisSpacing: 8.w,
      childAspectRatio: 1.9,
      children: [
        for (final slot in slots)
          _SlotChip(slot: slot, isSelected: slot == selected, onTap: () => onSelect(slot)),
      ],
    );
  }
}

class _SlotChip extends StatelessWidget {
  const _SlotChip({required this.slot, required this.isSelected, required this.onTap});

  final TimeTableSlotModel slot;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final disabled = !slot.available;

    final bg = isSelected ? primary : (disabled ? AppColors.surfaceColor.themeColor : AppColors.cardColor.themeColor);
    final border = isSelected || disabled ? Colors.transparent : AppColors.dividerColor.themeColor;
    final textColor = isSelected
        ? Colors.white
        : disabled
            ? AppColors.hintColor.themeColor
            : AppColors.textPrimaryColor.themeColor;

    return GestureDetector(
      onTap: disabled ? null : onTap,
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: border),
        ),
        child: Text(slot.displayLabel,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: textColor,
              decoration: disabled ? TextDecoration.lineThrough : null,
            )),
      ),
    );
  }
}
