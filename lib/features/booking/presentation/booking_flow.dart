import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../core/di/injection.dart';
import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/custom_loading_widget.dart';
import '../../../core/widgets/guest_login_dialog.dart';
import '../../../core/widgets/price_text.dart';
import '../../offers/data/models/applied_offer.dart';
import '../../payments/presentation/widgets/payment_sheet.dart';
import '../data/booking_repo.dart';
import '../data/models/doctor_profile_model.dart';
import '../logic/appointments_cubit.dart';
import 'widgets/booking_confirmed_dialog.dart';
import 'widgets/booking_slots_sheet.dart';

/// The full "book with this doctor" flow — slot sheet → guest gate → payment
/// sheet → `createAppointment` → confirmation dialog. Shared by [DoctorScreen]
/// (`_BookBar` / per-clinic buttons) and [DoctorCard]'s book action so both
/// behave identically, including the multi-clinic picker inside the slot sheet
/// when [clinicId] is `null`.
Future<void> startDoctorBooking(
  BuildContext context, {
  required DoctorProfileModel doctor,
  int? clinicId,
  AppliedOffer? offer,
}) async {
  final appointmentsCubit = getIt<AppointmentsCubit>();
  final price = doctor.price;
  final finalPrice = offer?.finalPriceFor(price) ?? price;
  final discounted = finalPrice < price;

  final slot = await showBookingSlotsSheet(context, doctor, clinicId: clinicId, offer: offer);
  if (slot == null || !context.mounted) return;

  // Gate right at the "confirm" step, not earlier — browsing a doctor and
  // their schedule stays open to a guest, but actually booking needs an
  // account. `requireGuestLogin` pushes the login flow and pops back here on
  // success, so `slot` (already picked) carries straight into payment below.
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

  final appointment = await appointmentsCubit.createAppointment(
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

  // Refreshes the singleton `AppointmentsCubit` so `HomeScreen`'s "upcoming
  // appointment" card picks up the new booking. Fire-and-forget so it doesn't
  // delay the confirmation dialog.
  unawaited(appointmentsCubit.getAppointments());

  showBookingConfirmedDialog(
    context,
    doctor: doctor.name,
    when: when,
    branch: doctor.clinicById(slot.clinicId)?.name ?? '',
  );
}

/// Fetches the full `GET /doctors/{id}` record (so the slot sheet's
/// multi-clinic logic has real data) and then runs [startDoctorBooking].
/// Used by [DoctorCard], whose doctor comes from the lighter list endpoint.
Future<void> bookDoctorById(
  BuildContext context, {
  required int doctorId,
  AppliedOffer? offer,
}) async {
  final loaderNavigator = Navigator.of(context, rootNavigator: true);
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black26,
    builder: (_) => Center(
      child: CustomLoadingWidget(color: AppColors.primaryColor.themeColor, size: 40),
    ),
  );

  DoctorProfileModel doctor;
  try {
    doctor = await getIt<BookingRepo>().getDoctorById(doctorId);
  } catch (e) {
    loaderNavigator.pop();
    AppOverlay.showError(
        e is NetworkException ? e.message : LocaleKeys.error_generic.tr());
    return;
  }

  loaderNavigator.pop();
  if (!context.mounted) return;
  await startDoctorBooking(context, doctor: doctor, offer: offer);
}
