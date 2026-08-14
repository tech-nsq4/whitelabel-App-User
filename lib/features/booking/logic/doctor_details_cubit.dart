import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/booking_repo.dart';
import '../data/models/doctor_profile_model.dart';

part 'doctor_details_state.dart';

class DoctorDetailsCubit extends Cubit<DoctorDetailsState> {
  DoctorDetailsCubit(this._repo) : super(const DoctorDetailsInitial());

  final BookingRepo _repo;

  Future<void> getDoctor(int id) async {
    emit(const DoctorDetailsLoading());
    try {
      final doctor = await _repo.getDoctorById(id);
      emit(DoctorDetailsSuccess(doctor));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(DoctorDetailsError(msg));
    }
  }
}
