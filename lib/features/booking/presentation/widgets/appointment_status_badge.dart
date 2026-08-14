import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';

/// Small colored pill for an [AppointmentModel.status] value ("pending",
/// "confirmed", "completed", "cancelled", ...) on `AppointmentDetailScreen`.
/// Falls back to the raw status string for any value the backend adds
/// later that isn't one of the known ones yet.
class AppointmentStatusBadge extends StatelessWidget {
  const AppointmentStatusBadge({super.key, required this.status});

  final String status;

  static const _labelKeys = {
    'pending': LocaleKeys.booking_statusPending,
    'confirmed': LocaleKeys.booking_statusConfirmed,
    'completed': LocaleKeys.booking_statusCompleted,
    'cancelled': LocaleKeys.booking_statusCancelled,
  };

  Color _color() {
    switch (status) {
      case 'confirmed':
      case 'completed':
        return AppColors.successColor.themeColor;
      case 'cancelled':
        return AppColors.errorColor.themeColor;
      default:
        return AppColors.accentGold.themeColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final color = _color();
    final label = _labelKeys[status]?.tr() ?? status;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(label, style: TextStyle(fontSize: 11.5.sp, fontWeight: FontWeight.w700, color: color)),
    );
  }
}
