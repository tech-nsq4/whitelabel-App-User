import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
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
import '../logic/appointments_cubit.dart';
import '../logic/my_bookings_cubit.dart';
import 'widgets/appointment_list_tile.dart';
import 'widgets/booking_confirmed_dialog.dart';
import 'widgets/booking_slots_sheet.dart';
import 'widgets/booking_status_tabs.dart';
import 'widgets/no_bookings_view.dart';
import 'widgets/rate_appointment_sheet.dart';

/// The account's booking history, backed by `GET /appointments` — reached
/// from `MedicalFileScreen`'s "حجوزاتي" row. [BookingStatusTabs] re-fetches
/// with the matching `status` query filter; each row carries the same
/// reschedule/cancel/book-again actions as `AppointmentDetailScreen`
/// (tapping the row itself still opens that screen for full details).
class MyBookingsScreen extends StatefulWidget {
  const MyBookingsScreen({super.key});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  late final MyBookingsCubit _cubit = getIt<MyBookingsCubit>();
  late final AppointmentsCubit _appointmentsCubit = getIt<AppointmentsCubit>();
  BookingStatusFilter _filter = BookingStatusFilter.all;

  @override
  void initState() {
    super.initState();
    _cubit.getAppointments();
  }

  @override
  void dispose() {
    _cubit.close();
    // `_appointmentsCubit` is the app-wide singleton `HomeScreen`'s
    // "upcoming appointment" card listens to (see `injection.dart`) — don't
    // close it here, it needs to stay alive after this screen is gone.
    super.dispose();
  }

  void _onSelectFilter(BookingStatusFilter filter) {
    setState(() => _filter = filter);
    _cubit.getAppointments(status: filter.apiValue);
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
      status: _filter.apiValue,
    );
    if (!ok || !mounted) return;

    AppOverlay.showSuccess(LocaleKeys.booking_rescheduleSuccess.tr());
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

    final ok = await _cubit.cancel(appointment.id, status: _filter.apiValue);
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
      status: _filter.apiValue,
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
    unawaited(_cubit.getAppointments(status: _filter.apiValue));

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
      child: BlocBuilder<MyBookingsCubit, MyBookingsState>(
        builder: (context, state) {
          final appointments = state is MyBookingsSuccess ? state.appointments : const [];

          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Column(
                  children: [
                    ScreenHeader(title: LocaleKeys.booking_myBookingsTitle.tr()),
                    BookingStatusTabs(selected: _filter, onSelect: _onSelectFilter),
                    14.height,
                    Expanded(
                      child: CustomScreenStateLayout(
                        isLoading: state is MyBookingsLoading || state is MyBookingsInitial,
                        error: state is MyBookingsError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: () => _cubit.getAppointments(status: _filter.apiValue),
                        isEmpty: appointments.isEmpty,
                        noDataBuilder: (_) => const NoBookingsView(),
                        builder: (context) => ListView.builder(
                          padding: EdgeInsets.only(bottom: 24.h),
                          itemCount: appointments.length,
                          itemBuilder: (context, index) {
                            final appointment = appointments[index];
                            return AppointmentListTile(
                              appointment: appointment,
                              onTap: () => Navigator.pushNamed(
                                context,
                                Routes.appointmentDetail,
                                arguments: {'id': appointment.id},
                              ),
                              onReschedule: () => _reschedule(appointment),
                              onCancel: () => _cancel(appointment),
                              onRate: () => _rate(appointment),
                              onBookAgain: () => _bookAgain(appointment),
                            );
                          },
                        ),
                      ),
                    ),
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
