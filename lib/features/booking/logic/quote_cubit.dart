import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/booking_repo.dart';
import '../data/models/appointment_quote_model.dart';

part 'quote_state.dart';

class QuoteCubit extends Cubit<QuoteState> {
  QuoteCubit(this._repo) : super(const QuoteInitial());

  final BookingRepo _repo;

  Future<void> applyPromoCode({
    required int doctorId,
    required DateTime date,
    int? clinicId,
    required String promoCode,
  }) async {
    emit(const QuoteLoading());
    try {
      final quote = await _repo.getAppointmentQuote(
        doctorId: doctorId,
        date: date,
        clinicId: clinicId,
        promoCode: promoCode,
      );
      emit(QuoteSuccess(quote));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(QuoteError(msg));
    }
  }

  void reset() => emit(const QuoteInitial());
}
