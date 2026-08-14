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

final class TimeTablesError extends TimeTablesState {
  final String message;
  const TimeTablesError(this.message);

  @override
  List<Object?> get props => [message];
}
