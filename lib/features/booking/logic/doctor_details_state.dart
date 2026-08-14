part of 'doctor_details_cubit.dart';

sealed class DoctorDetailsState extends Equatable {
  const DoctorDetailsState();

  @override
  List<Object?> get props => [];
}

final class DoctorDetailsInitial extends DoctorDetailsState {
  const DoctorDetailsInitial();
}

final class DoctorDetailsLoading extends DoctorDetailsState {
  const DoctorDetailsLoading();
}

final class DoctorDetailsSuccess extends DoctorDetailsState {
  final DoctorProfileModel doctor;
  const DoctorDetailsSuccess(this.doctor);

  @override
  List<Object?> get props => [doctor];
}

final class DoctorDetailsError extends DoctorDetailsState {
  final String message;
  const DoctorDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
