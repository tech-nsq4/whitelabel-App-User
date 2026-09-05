import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/models/offer_model.dart';
import '../data/offers_repo.dart';

part 'offers_state.dart';

class OffersCubit extends Cubit<OffersState> {
  OffersCubit(this._repo) : super(const OffersInitial());

  final OffersRepo _repo;

  Future<void> getOffers() async {
    emit(const OffersLoading());
    try {
      final offers = await _repo.getOffers();
      emit(OffersSuccess(offers));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(OffersError(msg));
    }
  }
}
