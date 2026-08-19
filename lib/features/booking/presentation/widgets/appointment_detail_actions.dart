import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../data/models/appointment_model.dart';

/// Bottom action(s) on `AppointmentDetailScreen`, driven by
/// [AppointmentModel.status] and its actual date/time:
/// - Hasn't happened yet (pending/confirmed/in_progress *and* still in the
///   future): reschedule + cancel.
/// - Completed/cancelled: book the same doctor again for a new slot.
/// - Any other case — including a pending/confirmed booking whose slot
///   already passed without the backend marking it completed/cancelled —
///   nothing: it's too late to reschedule or cancel, and it's not clearly
///   "done" enough to offer booking it again.
class AppointmentDetailActions extends StatelessWidget {
  const AppointmentDetailActions({
    super.key,
    required this.appointment,
    required this.onReschedule,
    required this.onCancel,
    required this.onBookAgain,
  });

  final AppointmentModel appointment;
  final VoidCallback onReschedule;
  final VoidCallback onCancel;
  final VoidCallback onBookAgain;

  static const _upcomingStatuses = {'pending', 'confirmed', 'in_progress'};
  static const _pastStatuses = {'completed', 'cancelled'};

  /// `true` once the booked slot's date/time is behind us — a `null`
  /// [AppointmentModel.dateTime] (missing/unparsable date) is treated as
  /// not-passed, so reschedule/cancel still show rather than silently
  /// disappearing.
  static bool _hasPassed(AppointmentModel appointment) {
    final dateTime = appointment.dateTime;
    return dateTime != null && dateTime.isBefore(DateTime.now());
  }

  /// Whether this widget renders any button for [appointment] — callers
  /// (`AppointmentListTile`'s divider, `AppointmentDetailScreen`'s spacing)
  /// check this first so they don't leave an orphan divider/gap above an
  /// empty [SizedBox.shrink].
  static bool hasActions(AppointmentModel appointment) =>
      (_upcomingStatuses.contains(appointment.status) && !_hasPassed(appointment)) ||
      _pastStatuses.contains(appointment.status);

  @override
  Widget build(BuildContext context) {
    if (_upcomingStatuses.contains(appointment.status) && !_hasPassed(appointment)) {
      return Row(
        children: [
          Expanded(
            child: CustomButton(
              title: LocaleKeys.booking_rescheduleAction.tr(),
              isOutlined: true,
              onTap: onReschedule,
            ),
          ),
          12.width,
          Expanded(
            child: CustomButton(
              title: LocaleKeys.booking_cancelAction.tr(),
              isOutlined: true,
              borderColor: AppColors.errorColor.themeColor,
              textColor: AppColors.errorColor.themeColor,
              onTap: onCancel,
            ),
          ),
        ],
      );
    }

    if (_pastStatuses.contains(appointment.status)) {
      return CustomButton(
        title: LocaleKeys.booking_bookAgainAction.tr(),
        onTap: onBookAgain,
      );
    }

    return const SizedBox.shrink();
  }
}
