part of 'family_cubit.dart';

sealed class FamilyState extends Equatable {
  const FamilyState();

  @override
  List<Object?> get props => [];
}

final class FamilyInitial extends FamilyState {
  const FamilyInitial();
}

final class FamilyLoading extends FamilyState {
  const FamilyLoading();
}

final class FamilySuccess extends FamilyState {
  final List<FamilyMemberModel> members;
  const FamilySuccess(this.members);

  @override
  List<Object?> get props => [members];
}

final class FamilyError extends FamilyState {
  final String message;
  const FamilyError(this.message);

  @override
  List<Object?> get props => [message];
}
