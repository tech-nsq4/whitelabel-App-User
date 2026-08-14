part of 'appointment_detail_cubit.dart';

sealed class AppointmentDetailState extends Equatable {
  const AppointmentDetailState();

  @override
  List<Object?> get props => [];
}

final class AppointmentDetailInitial extends AppointmentDetailState {
  const AppointmentDetailInitial();
}

final class AppointmentDetailLoading extends AppointmentDetailState {
  const AppointmentDetailLoading();
}

final class AppointmentDetailSuccess extends AppointmentDetailState {
  final AppointmentModel appointment;
  const AppointmentDetailSuccess(this.appointment);

  @override
  List<Object?> get props => [appointment];
}

final class AppointmentDetailError extends AppointmentDetailState {
  final String message;
  const AppointmentDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
