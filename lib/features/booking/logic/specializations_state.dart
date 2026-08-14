part of 'specializations_cubit.dart';

sealed class SpecializationsState extends Equatable {
  const SpecializationsState();

  @override
  List<Object?> get props => [];
}

final class SpecializationsInitial extends SpecializationsState {
  const SpecializationsInitial();
}

final class SpecializationsLoading extends SpecializationsState {
  const SpecializationsLoading();
}

final class SpecializationsSuccess extends SpecializationsState {
  final List<SpecializationModel> specializations;
  const SpecializationsSuccess(this.specializations);

  @override
  List<Object?> get props => [specializations];
}

final class SpecializationsError extends SpecializationsState {
  final String message;
  const SpecializationsError(this.message);

  @override
  List<Object?> get props => [message];
}
