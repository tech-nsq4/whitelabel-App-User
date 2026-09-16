part of 'quote_cubit.dart';

sealed class QuoteState extends Equatable {
  const QuoteState();

  @override
  List<Object?> get props => [];
}

final class QuoteInitial extends QuoteState {
  const QuoteInitial();
}

final class QuoteLoading extends QuoteState {
  const QuoteLoading();
}

final class QuoteSuccess extends QuoteState {
  final AppointmentQuoteModel quote;
  const QuoteSuccess(this.quote);

  @override
  List<Object?> get props => [quote];
}

final class QuoteError extends QuoteState {
  final String message;
  const QuoteError(this.message);

  @override
  List<Object?> get props => [message];
}
