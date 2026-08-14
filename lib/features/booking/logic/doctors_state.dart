part of 'doctors_cubit.dart';

sealed class DoctorsState extends Equatable {
  const DoctorsState();

  @override
  List<Object?> get props => [];
}

final class DoctorsInitial extends DoctorsState {
  const DoctorsInitial();
}

final class DoctorsLoading extends DoctorsState {
  const DoctorsLoading();
}

final class DoctorsSuccess extends DoctorsState {
  final List<DoctorProfileModel> doctors;
  const DoctorsSuccess(this.doctors);

  @override
  List<Object?> get props => [doctors];
}

final class DoctorsError extends DoctorsState {
  final String message;
  const DoctorsError(this.message);

  @override
  List<Object?> get props => [message];
}
