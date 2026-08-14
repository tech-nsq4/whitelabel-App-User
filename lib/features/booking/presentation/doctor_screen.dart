import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../payments/presentation/widgets/payment_sheet.dart';
import '../data/models/doctor_profile_model.dart';
import '../logic/appointments_cubit.dart';
import '../logic/doctor_details_cubit.dart';
import 'widgets/booking_confirmed_dialog.dart';
import 'widgets/booking_slots_sheet.dart';
import 'widgets/doctor_profile_body.dart';

/// Doctor profile / booking-entry screen, backed by `GET /doctors/{id}`.
class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key, required this.doctorId});

  final int doctorId;

  @override
  State<DoctorScreen> createState() => _DoctorScreenState();
}

class _DoctorScreenState extends State<DoctorScreen> {
  late final DoctorDetailsCubit _cubit = getIt<DoctorDetailsCubit>();
  late final AppointmentsCubit _appointmentsCubit = getIt<AppointmentsCubit>();

  @override
  void initState() {
    super.initState();
    _cubit.getDoctor(widget.doctorId);
  }

  @override
  void dispose() {
    _cubit.close();
    // `_appointmentsCubit` is the app-wide singleton `HomeScreen`'s
    // "upcoming appointment" card listens to (see `injection.dart`) — don't
    // close it here, it needs to stay alive after this screen is gone.
    super.dispose();
  }

  Future<void> _book(BuildContext context, DoctorProfileModel doctor) async {
    final slot = await showBookingSlotsSheet(context, doctor);
    if (slot == null || !context.mounted) return;

    final locale = context.locale.languageCode;
    final when = '${slot.dayLabel(locale)} · ${slot.timeLabel}';

    final paid = await showPaymentSheet(
      context,
      title: doctor.name,
      detail: '${doctor.name} · $when',
      amountLabel: '${doctor.price.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}',
    );
    if (paid != true || !context.mounted) return;

    final appointment = await _appointmentsCubit.createAppointment(
      doctorId: doctor.id,
      timeTableId: slot.slot.timeTableId,
      scheduleId: slot.slot.scheduleId,
      shiftId: slot.slot.shift,
      times: slot.slot.time,
      date: slot.date,
      familyMemberId: slot.familyMember?.id,
    );
    if (appointment == null || !context.mounted) return;

    // Refreshes the singleton `AppointmentsCubit` so `HomeScreen`'s
    // "upcoming appointment" card picks up the new booking the moment the
    // user navigates back — no manual refresh needed. Fire-and-forget so
    // it doesn't delay the confirmation dialog below.
    unawaited(_appointmentsCubit.getAppointments());

    showBookingConfirmedDialog(
      context,
      doctor: doctor.name,
      when: when,
      branch: doctor.clinic?.name ?? '',
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _cubit,
      child: BlocBuilder<DoctorDetailsCubit, DoctorDetailsState>(
        builder: (context, state) {
          return Scaffold(
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: Column(
                  children: [
                    ScreenHeader(title: LocaleKeys.booking_doctorProfileTitle.tr()),
                    Expanded(
                      child: CustomScreenStateLayout(
                        isLoading: state is DoctorDetailsLoading || state is DoctorDetailsInitial,
                        error: state is DoctorDetailsError
                            ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
                            : null,
                        onRetry: () => _cubit.getDoctor(widget.doctorId),
                        builder: (context) {
                          final doctor = (state as DoctorDetailsSuccess).doctor;
                          return DoctorProfileBody(doctor: doctor, onBook: () => _book(context, doctor));
                        },
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
