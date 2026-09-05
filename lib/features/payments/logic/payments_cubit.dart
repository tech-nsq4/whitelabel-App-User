import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/models/payments_summary_model.dart';
import '../data/payments_repo.dart';

part 'payments_state.dart';

class PaymentsCubit extends Cubit<PaymentsState> {
  PaymentsCubit(this._repo) : super(const PaymentsInitial());

  final PaymentsRepo _repo;

  Future<void> getPayments() async {
    emit(const PaymentsLoading());
    try {
      final summary = await _repo.getPayments();
      emit(PaymentsSuccess(summary));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(PaymentsError(msg));
    }
  }
}
