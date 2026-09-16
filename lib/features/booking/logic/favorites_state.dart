part of 'favorites_cubit.dart';

sealed class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

final class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

final class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

final class FavoritesSuccess extends FavoritesState {
  final List<DoctorClinicModel> branches;
  const FavoritesSuccess(this.branches);

  bool contains(int clinicId) => branches.any((b) => b.id == clinicId);

  @override
  List<Object?> get props => [branches];
}

final class FavoritesError extends FavoritesState {
  final String message;
  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}
