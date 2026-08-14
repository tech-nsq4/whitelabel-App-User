import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
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
}
