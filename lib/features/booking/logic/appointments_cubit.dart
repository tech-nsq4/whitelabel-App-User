import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../data/booking_repo.dart';
import '../data/models/appointment_model.dart';

part 'appointments_state.dart';

class AppointmentsCubit extends Cubit<AppointmentsState> {
  AppointmentsCubit(this._repo) : super(const AppointmentsInitial());

  final BookingRepo _repo;

  Future<void> getAppointments() async {
    emit(const AppointmentsLoading());
    try {
      final appointments = await _repo.getAppointments();
      emit(AppointmentsSuccess(appointments));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(AppointmentsError(msg));
    }
  }

  /// Books the appointment picked on `BookingSlotsSheet`. Deliberately
  /// doesn't touch [AppointmentsState] on failure (only shows the error
  /// overlay) — `DoctorScreen` drives its own flow off this method's
  /// return value instead of off [state].
  Future<AppointmentModel?> createAppointment({
    required int doctorId,
    required int timeTableId,
    required int scheduleId,
    required String shiftId,
    required String times,
    required DateTime date,
    int? familyMemberId,
  }) async {
    try {
      return await _repo.createAppointment(
        doctorId: doctorId,
        timeTableId: timeTableId,
        scheduleId: scheduleId,
        shiftId: shiftId,
        times: times,
        date: date,
        familyMemberId: familyMemberId,
      );
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      return null;
    }
  }
}
