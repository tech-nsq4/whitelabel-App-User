import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/booking_repo.dart';
import '../data/models/doctor_profile_model.dart';

part 'doctors_state.dart';

class DoctorsCubit extends Cubit<DoctorsState> {
  DoctorsCubit(this._repo) : super(const DoctorsInitial());

  final BookingRepo _repo;

  Future<void> getDoctors({
    int? specializationId,
    int? clinicId,
    String? name,
    double? lat,
    double? lng,
  }) async {
    emit(const DoctorsLoading());
    try {
      final doctors = await _repo.getDoctors(
        specializationId: specializationId,
        clinicId: clinicId,
        name: name,
        lat: lat,
        lng: lng,
      );
      emit(DoctorsSuccess(doctors));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(DoctorsError(msg));
    }
  }
}
