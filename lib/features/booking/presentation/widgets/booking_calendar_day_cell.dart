import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';

enum CalendarDayState { unavailable, available, selected }

/// One day cell in [BookingCalendar]'s grid — plain/muted when
/// [CalendarDayState.unavailable] (not tappable), a light highlight with
/// the slot count when [CalendarDayState.available], filled solid when
/// [CalendarDayState.selected].
class CalendarDayCell extends StatelessWidget {
  const CalendarDayCell({
    super.key,
    required this.day,
    required this.count,
    required this.state,
    required this.onTap,
  });

  final int day;
  final int count;
  final CalendarDayState state;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isSelected = state == CalendarDayState.selected;
    final isAvailable = state == CalendarDayState.available;
    final primary = AppColors.primaryColor.themeColor;

    final bg = isSelected
        ? primary
        : isAvailable
            ? AppColors.surfaceColor.themeColor
            : Colors.transparent;
    final numberColor = isSelected
        ? Colors.white
        : isAvailable
            ? AppColors.textPrimaryColor.themeColor
            : AppColors.hintColor.themeColor;
    final countColor = isSelected ? Colors.white.withValues(alpha: 0.85) : primary;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(2.r),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12.r)),
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$day', style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w600, color: numberColor)),
            if (isAvailable || isSelected) ...[
              1.height,
              Text('$count', style: TextStyle(fontSize: 9.5.sp, fontWeight: FontWeight.w700, color: countColor)),
            ],
          ],
        ),
      ),
    );
  }
}
