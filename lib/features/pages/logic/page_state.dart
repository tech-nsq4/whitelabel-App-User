part of 'page_cubit.dart';

sealed class PageState extends Equatable {
  const PageState();

  @override
  List<Object?> get props => [];
}

final class PageInitial extends PageState {
  const PageInitial();
}

final class PageLoading extends PageState {
  const PageLoading();
}

final class PageSuccess extends PageState {
  final ContentPageModel page;
  const PageSuccess(this.page);

  @override
  List<Object?> get props => [page];
}

final class PageError extends PageState {
  final String message;
  const PageError(this.message);

  @override
  List<Object?> get props => [message];
}
