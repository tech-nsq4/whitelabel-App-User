import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../data/booking_repo.dart';
import '../data/models/appointment_model.dart';

part 'appointment_detail_state.dart';

class AppointmentDetailCubit extends Cubit<AppointmentDetailState> {
  AppointmentDetailCubit(this._repo) : super(const AppointmentDetailInitial());

  final BookingRepo _repo;

  Future<void> getAppointment(int id) async {
    emit(const AppointmentDetailLoading());
    try {
      final appointment = await _repo.getAppointmentById(id);
      emit(AppointmentDetailSuccess(appointment));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(AppointmentDetailError(msg));
    }
  }

  /// Moves [appointmentId] to the new doctor/slot picked on
  /// `BookingSlotsSheet`, then reloads it so the screen reflects the new
  /// date/time/status. `false` on failure (only shows the error overlay —
  /// [state] is left as-is, same as `AppointmentsCubit.createAppointment`).
  Future<bool> reschedule({
    required int appointmentId,
    required int doctorId,
    required int timeTableId,
    required int scheduleId,
    required String shiftId,
    required String times,
    required DateTime date,
    int? clinicId,
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
        clinicId: clinicId,
      );
      await getAppointment(appointmentId);
      return true;
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      return false;
    }
  }

  /// Cancels [appointmentId], then reloads it so the badge flips to
  /// "cancelled". `false` on failure (only shows the error overlay).
  Future<bool> cancel(int appointmentId) async {
    try {
      await _repo.cancelAppointment(appointmentId);
      await getAppointment(appointmentId);
      return true;
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      return false;
    }
  }

  /// Rates a completed [appointmentId], then reloads it so the "rate" action
  /// disappears. `false` on failure (only shows the error overlay).
  Future<bool> rate({required int appointmentId, required int rate, String? comment}) async {
    try {
      await _repo.rateAppointment(appointmentId: appointmentId, rate: rate, comment: comment);
      await getAppointment(appointmentId);
      return true;
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      return false;
    }
  }
}
