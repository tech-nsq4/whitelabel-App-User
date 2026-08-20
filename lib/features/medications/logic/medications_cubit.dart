import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../booking/data/models/appointment_model.dart';
import '../data/medications_repo.dart';

part 'medications_state.dart';

class MedicationsCubit extends Cubit<MedicationsState> {
  MedicationsCubit(this._repo) : super(const MedicationsInitial());

  final MedicationsRepo _repo;

  Future<void> getPrescriptions() async {
    emit(const MedicationsLoading());
    try {
      final items = await _repo.getPrescriptionsHistory();
      emit(MedicationsSuccess(items));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(MedicationsError(msg));
    }
  }
}
