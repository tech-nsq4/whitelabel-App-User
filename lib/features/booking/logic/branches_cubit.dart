import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/booking_repo.dart';
import '../data/models/doctor_profile_model.dart';

part 'branches_state.dart';

class BranchesCubit extends Cubit<BranchesState> {
  BranchesCubit(this._repo) : super(const BranchesInitial());

  final BookingRepo _repo;

  Future<void> getBranches() async {
    emit(const BranchesLoading());
    try {
      final branches = await _repo.getBranches();
      emit(BranchesSuccess(branches));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(BranchesError(msg));
    }
  }
}
