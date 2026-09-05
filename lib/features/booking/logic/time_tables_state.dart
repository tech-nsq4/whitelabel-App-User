part of 'time_tables_cubit.dart';

sealed class TimeTablesState extends Equatable {
  const TimeTablesState();

  @override
  List<Object?> get props => [];
}

final class TimeTablesInitial extends TimeTablesState {
  const TimeTablesInitial();
}

final class TimeTablesLoading extends TimeTablesState {
  const TimeTablesLoading();
}

final class TimeTablesSuccess extends TimeTablesState {
  final DoctorAvailability availability;
  const TimeTablesSuccess(this.availability);

  @override
  List<Object?> get props => [availability];
}

/// A day was just picked on the calendar and its real booked/available
/// slots are being re-fetched from the backend (`?date=...`) — [availability]
/// is still the last known-good calendar (so it keeps rendering normally,
/// unaffected), only the slot grid for [date] should show a loading state.
final class TimeTablesDaySlotsLoading extends TimeTablesState {
  final DoctorAvailability availability;
  final DateTime date;
  const TimeTablesDaySlotsLoading(this.availability, this.date);

  @override
  List<Object?> get props => [availability, date];
}

final class TimeTablesError extends TimeTablesState {
  final String message;
  const TimeTablesError(this.message);

  @override
  List<Object?> get props => [message];
}
