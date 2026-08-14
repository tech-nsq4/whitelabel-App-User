part of 'branches_cubit.dart';

sealed class BranchesState extends Equatable {
  const BranchesState();

  @override
  List<Object?> get props => [];
}

final class BranchesInitial extends BranchesState {
  const BranchesInitial();
}

final class BranchesLoading extends BranchesState {
  const BranchesLoading();
}

final class BranchesSuccess extends BranchesState {
  final List<DoctorClinicModel> branches;
  const BranchesSuccess(this.branches);

  @override
  List<Object?> get props => [branches];
}

final class BranchesError extends BranchesState {
  final String message;
  const BranchesError(this.message);

  @override
  List<Object?> get props => [message];
}
