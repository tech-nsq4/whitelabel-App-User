part of 'medications_cubit.dart';

sealed class MedicationsState extends Equatable {
  const MedicationsState();

  @override
  List<Object?> get props => [];
}

final class MedicationsInitial extends MedicationsState {
  const MedicationsInitial();
}

final class MedicationsLoading extends MedicationsState {
  const MedicationsLoading();
}

final class MedicationsSuccess extends MedicationsState {
  final List<PrescriptionModel> prescriptions;
  const MedicationsSuccess(this.prescriptions);

  @override
  List<Object?> get props => [prescriptions];
}

final class MedicationsError extends MedicationsState {
  final String message;
  const MedicationsError(this.message);

  @override
  List<Object?> get props => [message];
}
