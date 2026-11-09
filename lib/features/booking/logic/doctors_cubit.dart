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
    int? subSpecializationId,
    int? clinicId,
    String? name,
    String? sort,
    double? lat,
    double? lng,
    bool onlineOnly = false,
    bool homeVisitOnly = false,
    int? homeVisitCityId,
    int? homeVisitAreaId,
  }) async {
    emit(const DoctorsLoading());
    try {
      final doctors = await _repo.getDoctors(
        specializationId: specializationId,
        subSpecializationId: subSpecializationId,
        clinicId: clinicId,
        name: name,
        sort: sort,
        lat: lat,
        lng: lng,
        onlineOnly: onlineOnly,
        homeVisitOnly: homeVisitOnly,
        homeVisitCityId: homeVisitCityId,
        homeVisitAreaId: homeVisitAreaId,
      );
      emit(DoctorsSuccess(doctors));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(DoctorsError(msg));
    }
  }
}
