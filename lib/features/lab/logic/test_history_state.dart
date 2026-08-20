part of 'test_history_cubit.dart';

sealed class TestHistoryState extends Equatable {
  const TestHistoryState();

  @override
  List<Object?> get props => [];
}

final class TestHistoryInitial extends TestHistoryState {
  const TestHistoryInitial();
}

final class TestHistoryLoading extends TestHistoryState {
  const TestHistoryLoading();
}

final class TestHistorySuccess extends TestHistoryState {
  final List<TestRequestModel> items;
  const TestHistorySuccess(this.items);

  @override
  List<Object?> get props => [items];
}

final class TestHistoryError extends TestHistoryState {
  final String message;
  const TestHistoryError(this.message);

  @override
  List<Object?> get props => [message];
}
