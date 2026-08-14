import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/booking_repo.dart';
import '../data/models/doctor_time_table_model.dart';

part 'time_tables_state.dart';

class TimeTablesCubit extends Cubit<TimeTablesState> {
  TimeTablesCubit(this._repo) : super(const TimeTablesInitial());

  final BookingRepo _repo;

  Future<void> getTimeTables(int doctorId) async {
    emit(const TimeTablesLoading());
    try {
      final timeTables = await _repo.getDoctorTimeTables(doctorId);
      emit(TimeTablesSuccess(DoctorAvailability(timeTables)));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(TimeTablesError(msg));
    }
  }
}
