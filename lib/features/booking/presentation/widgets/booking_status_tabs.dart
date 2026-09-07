import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';

/// A `MyBookingsScreen` status tab. [apiValue] is the exact `status` query
/// value `GET /appointments` accepts — `null` for [all], which sends no
/// `status` param at all and gets every appointment back.
enum BookingStatusFilter {
  all(null),
  pending('pending'),
  confirmed('confirmed'),
  completed('completed'),
  cancelled('cancelled');

  const BookingStatusFilter(this.apiValue);
  final String? apiValue;
}

/// Horizontally-scrollable status tabs on `MyBookingsScreen` — one pill per
/// [BookingStatusFilter].
class BookingStatusTabs extends StatelessWidget {
  const BookingStatusTabs({super.key, required this.selected, required this.onSelect});

  final BookingStatusFilter selected;
  final ValueChanged<BookingStatusFilter> onSelect;

  String _label(BookingStatusFilter filter) {
    switch (filter) {
      case BookingStatusFilter.all:
        return LocaleKeys.booking_statusAll.tr();
      case BookingStatusFilter.pending:
        return LocaleKeys.booking_statusPending.tr();
      case BookingStatusFilter.confirmed:
        return LocaleKeys.booking_statusConfirmed.tr();
      case BookingStatusFilter.completed:
        return LocaleKeys.booking_statusCompleted.tr();
      case BookingStatusFilter.cancelled:
        return LocaleKeys.booking_statusCancelled.tr();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (final filter in BookingStatusFilter.values) ...[
            _StatusTab(
              label: _label(filter),
              isSelected: selected == filter,
              onTap: () => onSelect(filter),
            ),
            8.width,
          ],
        ],
      ),
    );
  }
}

class _StatusTab extends StatelessWidget {
  const _StatusTab({required this.label, required this.isSelected, required this.onTap});

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? primary : AppColors.cardColor.themeColor,
          border: Border.all(color: isSelected ? Colors.transparent : AppColors.dividerColor.themeColor),
          borderRadius: BorderRadius.circular(99),
        ),
        child: Text(label,
            style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textSecondaryColor.themeColor)),
      ),
    );
  }
}
