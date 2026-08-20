import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../booking/data/models/appointment_model.dart';
import '../data/lab_repo.dart';

part 'test_history_state.dart';

/// Which flat history list `TestHistoryScreen`/[TestHistoryCubit] is
/// showing — drives both the fetched endpoint and the screen's title.
enum TestHistoryType { analysis, xray }

class TestHistoryCubit extends Cubit<TestHistoryState> {
  TestHistoryCubit(this._repo) : super(const TestHistoryInitial());

  final LabRepo _repo;

  Future<void> getHistory(TestHistoryType type) async {
    emit(const TestHistoryLoading());
    try {
      final items = type == TestHistoryType.analysis
          ? await _repo.getAnalysesHistory()
          : await _repo.getXraysHistory();
      emit(TestHistorySuccess(items));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(TestHistoryError(msg));
    }
  }
}
