part of 'offers_cubit.dart';

sealed class OffersState extends Equatable {
  const OffersState();

  @override
  List<Object?> get props => [];
}

final class OffersInitial extends OffersState {
  const OffersInitial();
}

final class OffersLoading extends OffersState {
  const OffersLoading();
}

final class OffersSuccess extends OffersState {
  final List<OfferModel> offers;
  const OffersSuccess(this.offers);

  @override
  List<Object?> get props => [offers];
}

final class OffersError extends OffersState {
  final String message;
  const OffersError(this.message);

  @override
  List<Object?> get props => [message];
}
