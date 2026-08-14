import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../data/models/doctor_time_table_model.dart';
import 'booking_calendar_day_cell.dart';

/// Month calendar for [BookingSlotsSheet] — each day cell shows how many
/// appointments (if any) are available that day, computed from
/// [availability]. Week starts Saturday (RTL-read row: سبت … أحد).
class BookingCalendar extends StatelessWidget {
  const BookingCalendar({
    super.key,
    required this.month,
    required this.selectedDate,
    required this.availability,
    required this.earliestSelectableDate,
    required this.onSelectDate,
    required this.onPrevMonth,
    required this.onNextMonth,
    required this.canGoPrev,
    required this.canGoNext,
  });

  final DateTime month;
  final DateTime? selectedDate;
  final DoctorAvailability availability;
  final DateTime earliestSelectableDate;
  final ValueChanged<DateTime> onSelectDate;
  final VoidCallback onPrevMonth;
  final VoidCallback onNextMonth;
  final bool canGoPrev;
  final bool canGoNext;

  static const _weekdayKeys = [
    LocaleKeys.calendar_sat,
    LocaleKeys.calendar_fri,
    LocaleKeys.calendar_thu,
    LocaleKeys.calendar_wed,
    LocaleKeys.calendar_tue,
    LocaleKeys.calendar_mon,
    LocaleKeys.calendar_sun,
  ];

  List<DateTime?> _grid() {
    final firstDay = DateTime(month.year, month.month, 1);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leading = firstDay.weekday == DateTime.sunday ? 6 : (DateTime.saturday - firstDay.weekday) % 7;
    return [
      ...List<DateTime?>.filled(leading, null),
      for (var d = 1; d <= daysInMonth; d++) DateTime(month.year, month.month, d),
    ];
  }

  bool _isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    final monthLabel = DateFormat('MMMM y', context.locale.languageCode).format(month);

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _NavButton(icon: Icons.chevron_right_rounded, onTap: canGoPrev ? onPrevMonth : null),
                8.width,
                _NavButton(icon: Icons.chevron_left_rounded, onTap: canGoNext ? onNextMonth : null),
              ],
            ),
            Text(monthLabel,
                style:
                    TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700, color: AppColors.textPrimaryColor.themeColor)),
          ],
        ),
        14.height,
        Row(
          children: [
            for (final key in _weekdayKeys)
              Expanded(
                child: Center(
                  child: Text(key.tr(),
                      style: TextStyle(
                          fontSize: 10.5.sp, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor)),
                ),
              ),
          ],
        ),
        8.height,
        GridView.count(
          crossAxisCount: 7,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final date in _grid())
              if (date == null)
                const SizedBox.shrink()
              else
                Builder(builder: (context) {
                  final isBeforeEarliest = date.isBefore(earliestSelectableDate);
                  final count = isBeforeEarliest ? 0 : availability.availableCountFor(date);
                  final isSelected = selectedDate != null && _isSameDay(date, selectedDate!);
                  final state = isSelected
                      ? CalendarDayState.selected
                      : count > 0
                          ? CalendarDayState.available
                          : CalendarDayState.unavailable;
                  return CalendarDayCell(
                    day: date.day,
                    count: count,
                    state: state,
                    onTap: state == CalendarDayState.unavailable ? null : () => onSelectDate(date),
                  );
                }),
          ],
        ),
        10.height,
        Text(LocaleKeys.booking_calendarLegend.tr(),
            style: TextStyle(fontSize: 10.sp, color: AppColors.mutedColor.themeColor)),
      ],
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final enabled = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30.r,
        height: 30.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.surfaceColor.themeColor,
          border: Border.all(color: AppColors.dividerColor.themeColor),
        ),
        child: Icon(icon, size: 16.sp, color: enabled ? AppColors.textPrimaryColor.themeColor : AppColors.hintColor.themeColor),
      ),
    );
  }
}
