import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../data/booking_repo.dart';
import '../data/models/appointment_model.dart';

part 'my_bookings_state.dart';

/// Backs `MyBookingsScreen`'s status tabs (and the reschedule/cancel
/// buttons on each row). Deliberately its own per-screen instance
/// (`registerFactory`, not the app-wide `AppointmentsCubit` singleton
/// `HomeScreen` reads) — switching tabs here re-fetches a status-filtered
/// subset, and sharing the singleton would leave it holding that subset
/// instead of the full list `HomeScreen` needs.
class MyBookingsCubit extends Cubit<MyBookingsState> {
  MyBookingsCubit(this._repo) : super(const MyBookingsInitial());

  final BookingRepo _repo;

  /// [status] is one of the API's filter values ("pending" | "confirmed" |
  /// "completed" | "cancelled") — `null` fetches every appointment.
  Future<void> getAppointments({String? status}) async {
    emit(const MyBookingsLoading());
    try {
      final appointments = await _repo.getAppointments(status: status);
      emit(MyBookingsSuccess(appointments));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(MyBookingsError(msg));
    }
  }

  /// Moves [appointmentId] to the new doctor/slot picked on
  /// `BookingSlotsSheet`, then re-fetches the list under [status] (the tab
  /// currently selected on `MyBookingsScreen`). `false` on failure (only
  /// shows the error overlay — [state] is left as-is).
  Future<bool> reschedule({
    required int appointmentId,
    required int doctorId,
    required int timeTableId,
    required int scheduleId,
    required String shiftId,
    required String times,
    required DateTime date,
    required String? status,
  }) async {
    try {
      await _repo.rescheduleAppointment(
        appointmentId: appointmentId,
        doctorId: doctorId,
        timeTableId: timeTableId,
        scheduleId: scheduleId,
        shiftId: shiftId,
        times: times,
        date: date,
      );
      await getAppointments(status: status);
      return true;
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      return false;
    }
  }

  /// Cancels [appointmentId], then re-fetches the list under [status].
  /// `false` on failure (only shows the error overlay).
  Future<bool> cancel(int appointmentId, {required String? status}) async {
    try {
      await _repo.cancelAppointment(appointmentId);
      await getAppointments(status: status);
      return true;
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      return false;
    }
  }

  /// Rates a completed [appointmentId], then re-fetches the list under
  /// [status] so the row picks up the new rating. `false` on failure (only
  /// shows the error overlay).
  Future<bool> rate({
    required int appointmentId,
    required int rate,
    String? comment,
    required String? status,
  }) async {
    try {
      await _repo.rateAppointment(appointmentId: appointmentId, rate: rate, comment: comment);
      await getAppointments(status: status);
      return true;
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      return false;
    }
  }
}
