part of 'unread_count_cubit.dart';

sealed class UnreadCountState extends Equatable {
  const UnreadCountState();

  @override
  List<Object?> get props => [];
}

final class UnreadCountInitial extends UnreadCountState {
  const UnreadCountInitial();
}

final class UnreadCountSuccess extends UnreadCountState {
  final int count;
  const UnreadCountSuccess(this.count);

  @override
  List<Object?> get props => [count];
}
