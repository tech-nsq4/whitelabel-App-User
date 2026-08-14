part of 'appointments_cubit.dart';

sealed class AppointmentsState extends Equatable {
  const AppointmentsState();

  @override
  List<Object?> get props => [];
}

final class AppointmentsInitial extends AppointmentsState {
  const AppointmentsInitial();
}

final class AppointmentsLoading extends AppointmentsState {
  const AppointmentsLoading();
}

final class AppointmentsSuccess extends AppointmentsState {
  final List<AppointmentModel> appointments;
  const AppointmentsSuccess(this.appointments);

  /// The soonest appointment that hasn't happened yet (and isn't
  /// cancelled) — backs the home screen's "upcoming appointment" card.
  /// `null` when there's none.
  AppointmentModel? get nextUpcoming {
    final now = DateTime.now();
    final upcoming = appointments.where((a) {
      if (a.status == 'cancelled') return false;
      final dt = a.dateTime;
      return dt != null && dt.isAfter(now);
    }).toList()
      ..sort((a, b) => a.dateTime!.compareTo(b.dateTime!));
    return upcoming.isEmpty ? null : upcoming.first;
  }

  @override
  List<Object?> get props => [appointments];
}

final class AppointmentsError extends AppointmentsState {
  final String message;
  const AppointmentsError(this.message);

  @override
  List<Object?> get props => [message];
}
