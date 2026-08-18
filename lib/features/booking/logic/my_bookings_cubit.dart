import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/booking_repo.dart';
import '../data/models/appointment_model.dart';

part 'my_bookings_state.dart';

/// Backs `MyBookingsScreen`'s status tabs. Deliberately its own per-screen
/// instance (`registerFactory`, not the app-wide `AppointmentsCubit`
/// singleton `HomeScreen` reads) — switching tabs here re-fetches a
/// status-filtered subset, and sharing the singleton would leave it holding
/// that subset instead of the full list `HomeScreen` needs.
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
}
