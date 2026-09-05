import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../payments/presentation/widgets/payment_sheet.dart';
import '../data/models/appointment_model.dart';
import '../logic/appointment_detail_cubit.dart';
import '../logic/appointments_cubit.dart';
import 'widgets/appointment_detail_actions.dart';
import 'widgets/appointment_detail_body.dart';
import 'widgets/booking_confirmed_dialog.dart';
import 'widgets/booking_slots_sheet.dart';
import 'widgets/rate_appointment_sheet.dart';

/// Appointment detail screen, backed by `GET /appointments/{id}` — reached
/// by tapping the home screen's "upcoming appointment" card or a row on
/// `MyBookingsScreen`. [AppointmentDetailActions] drives reschedule/cancel
/// (upcoming) or book-again (completed/cancelled) from here.
class AppointmentDetailScreen extends StatefulWidget {
  const AppointmentDetailScreen({super.key, required this.appointmentId});

  final int appointmentId;

  @override
  State<AppointmentDetailScreen> createState() => _AppointmentDetailScreenState();
}

class _AppointmentDetailScreenState extends State<AppointmentDetailScreen> {
  late final AppointmentDetailCubit _cubit = getIt<AppointmentDetailCubit>();
  late final AppointmentsCubit _appointmentsCubit = getIt<AppointmentsCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.getAppointment(widget.appointmentId);
  }

  @override
  void dispose() {
    _cubit.close();
    // `_appointmentsCubit` is the app-wide singleton `HomeScreen`'s
    // "upcoming appointment" card listens to (see `injection.dart`) — don't
    // close it here, it needs to stay alive after this screen is gone.
    super.dispose();
  }

  Future<void> _reschedule(AppointmentModel appointment) async {
    final doctor = appointment.doctor;
    if (doctor == null) return;

    final slot = await showBookingSlotsSheet(
      context,
      doctor,
      showFamilyMemberSelector: false,
      ctaLabel: LocaleKeys.booking_confirmReschedule.tr(),
      clinicId: doctor.clinic?.id,
    );
    if (slot == null || !mounted) return;

    final ok = await _cubit.reschedule(
      appointmentId: appointment.id,
      doctorId: doctor.id,
      timeTableId: slot.slot.timeTableId,
      scheduleId: slot.slot.scheduleId,
      shiftId: slot.slot.shift,
      times: slot.slot.time,
      date: slot.date,
      clinicId: slot.clinicId,
    );
    if (!ok || !mounted) return;

    AppOverlay.showSuccess(LocaleKeys.booking_rescheduleSuccess.tr());
    // Fire-and-forget: keeps the home screen's "upcoming appointment" card
    // in sync with the new date/time, same as after a fresh booking.
    unawaited(_appointmentsCubit.getAppointments());
  }

  Future<void> _cancel(AppointmentModel appointment) async {
    final confirmed = await showConfirmDialog(
      context,
      icon: Icons.event_busy_rounded,
      title: LocaleKeys.booking_cancelDialogTitle.tr(),
      message: LocaleKeys.booking_cancelDialogMessage.tr(),
      confirmLabel: LocaleKeys.booking_cancelDialogConfirm.tr(),
      cancelLabel: LocaleKeys.common_cancel.tr(),
      confirmColor: AppColors.errorColor.themeColor,
    );
    if (!confirmed || !mounted) return;

    final ok = await _cubit.cancel(appointment.id);
    if (!ok || !mounted) return;

    AppOverlay.showSuccess(LocaleKeys.booking_cancelSuccess.tr());
    unawaited(_appointmentsCubit.getAppointments());
  }

  Future<void> _rate(AppointmentModel appointment) async {
    final result = await showRateAppointmentSheet(context, doctorName: appointment.doctor?.name);
    if (result == null || !mounted) return;

    final ok = await _cubit.rate(
      appointmentId: appointment.id,
      rate: result.rate,
      comment: result.comment,
    );
    if (!ok || !mounted) return;

    AppOverlay.showSuccess(LocaleKeys.booking_rateSuccess.tr());
    unawaited(_appointmentsCubit.getAppointments());
  }

  Future<void> _bookAgain(AppointmentModel appointment) async {
    final doctor = appointment.doctor;
    if (doctor == null) return;

    final slot = await showBookingSlotsSheet(context, doctor, clinicId: doctor.clinic?.id);
    if (slot == null || !mounted) return;

    final locale = context.locale.languageCode;
    final when = '${slot.dayLabel(locale)} · ${slot.timeLabel}';

    final paid = await showPaymentSheet(
      context,
      title: doctor.name,
      detail: '${doctor.name} · $when',
      amountLabel: '${doctor.price.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
    );
    if (paid != true || !mounted) return;

    final newAppointment = await _appointmentsCubit.createAppointment(
      doctorId: doctor.id,
      timeTableId: slot.slot.timeTableId,
      scheduleId: slot.slot.scheduleId,
      shiftId: slot.slot.shift,
      times: slot.slot.time,
      date: slot.date,
      clinicId: slot.clinicId,
      familyMemberId: slot.familyMember?.id,
    );
    if (newAppointment == null || !mounted) return;

    unawaited(_appointmentsCubit.getAppointments());

    showBookingConfirmedDialog(
      context,
      doctor: doctor.name,
      when: when,
      branch: doctor.clinicById(slot.clinicId)?.name ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<AppointmentDetailCubit, AppointmentDetailState>(
        builder: (context, state) {
          final appointment = state is AppointmentDetailSuccess ? state.appointment : null;

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 16.h),
                child: Column(
                  children: [
                    ScreenHeader(title: LocaleKeys.booking_appointmentDetailsTitle.tr()),
                    Expanded(
                      child: CustomScreenStateLayout(
                        isLoading: state is AppointmentDetailLoading || state is AppointmentDetailInitial,
                        error: state is AppointmentDetailError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: () => _cubit.getAppointment(widget.appointmentId),
                        builder: (context) => AppointmentDetailBody(appointment: appointment!),
                      ),
                    ),
                    if (appointment != null && AppointmentDetailActions.hasActions(appointment)) ...[
                      14.height,
                      AppointmentDetailActions(
                        appointment: appointment,
                        onReschedule: () => _reschedule(appointment),
                        onCancel: () => _cancel(appointment),
                        onRate: () => _rate(appointment),
                        onBookAgain: () => _bookAgain(appointment),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
