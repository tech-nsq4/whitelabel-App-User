import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/booking_repo.dart';
import '../data/models/specialization_model.dart';

part 'specializations_state.dart';

class SpecializationsCubit extends Cubit<SpecializationsState> {
  SpecializationsCubit(this._repo) : super(const SpecializationsInitial());

  final BookingRepo _repo;

  Future<void> getSpecializations() async {
    emit(const SpecializationsLoading());
    try {
      final specializations = await _repo.getSpecializations();
      emit(SpecializationsSuccess(specializations));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(SpecializationsError(msg));
    }
  }
}
