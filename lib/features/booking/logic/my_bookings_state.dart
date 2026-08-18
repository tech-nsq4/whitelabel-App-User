part of 'my_bookings_cubit.dart';

sealed class MyBookingsState extends Equatable {
  const MyBookingsState();

  @override
  List<Object?> get props => [];
}

final class MyBookingsInitial extends MyBookingsState {
  const MyBookingsInitial();
}

final class MyBookingsLoading extends MyBookingsState {
  const MyBookingsLoading();
}

final class MyBookingsSuccess extends MyBookingsState {
  final List<AppointmentModel> appointments;
  const MyBookingsSuccess(this.appointments);

  @override
  List<Object?> get props => [appointments];
}

final class MyBookingsError extends MyBookingsState {
  final String message;
  const MyBookingsError(this.message);

  @override
  List<Object?> get props => [message];
}
