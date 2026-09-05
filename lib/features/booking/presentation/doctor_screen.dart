import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/di/injection.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/guest_login_dialog.dart';
import '../../../core/widgets/price_text.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/screen_state_layout.dart';
import '../../offers/data/models/applied_offer.dart';
import '../../payments/presentation/widgets/payment_sheet.dart';
import '../data/models/doctor_profile_model.dart';
import '../logic/appointments_cubit.dart';
import '../logic/doctor_details_cubit.dart';
import 'widgets/booking_confirmed_dialog.dart';
import 'widgets/booking_slots_sheet.dart';
import 'widgets/doctor_profile_body.dart';

/// Doctor profile / booking-entry screen, backed by `GET /doctors/{id}`.
class DoctorScreen extends StatefulWidget {
  const DoctorScreen({super.key, required this.doctorId, this.offer});

  final int doctorId;
  final AppliedOffer? offer;

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

  Future<void> _book(BuildContext context, DoctorProfileModel doctor, int? clinicId) async {
    final offer = widget.offer;
    final price = doctor.price;
    final finalPrice = offer?.finalPriceFor(price) ?? price;
    final discounted = finalPrice < price;

    final slot = await showBookingSlotsSheet(context, doctor, clinicId: clinicId, offer: offer);
    if (slot == null || !context.mounted) return;

    // Gate right at the "confirm" step, not earlier — browsing the doctor's
    // profile and schedule stays open to a guest, but actually booking
    // needs an account. `requireGuestLogin` pushes the login flow on top of
    // this screen and pops back here on success, so `slot` (already picked)
    // just carries straight through into the payment step below.
    if (kIsGuest) {
      final loggedIn = await requireGuestLogin(context);
      if (!loggedIn || !context.mounted) return;
    }

    final locale = context.locale.languageCode;
    final when = '${slot.dayLabel(locale)} · ${slot.timeLabel}';

    final result = await showPaymentSheet(
      context,
      title: doctor.name,
      detail: '${doctor.name} · $when',
      amountLabel: formatPriceLabel(finalPrice),
      strikeAmountLabel: discounted ? formatPriceLabel(price) : null,
      promoCodeEnabled: true,
    );
    if (result == null || !context.mounted) return;

    final appointment = await _appointmentsCubit.createAppointment(
      doctorId: doctor.id,
      timeTableId: slot.slot.timeTableId,
      scheduleId: slot.slot.scheduleId,
      shiftId: slot.slot.shift,
      times: slot.slot.time,
      date: slot.date,
      clinicId: slot.clinicId,
      familyMemberId: slot.familyMember?.id,
      offerId: offer?.id,
      promoCode: result.promoCode,
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
      branch: doctor.clinicById(slot.clinicId)?.name ?? '',
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
                          return DoctorProfileBody(
                              doctor: doctor,
                              offer: widget.offer,
                              onBook: (clinicId) => _book(context, doctor, clinicId));
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
