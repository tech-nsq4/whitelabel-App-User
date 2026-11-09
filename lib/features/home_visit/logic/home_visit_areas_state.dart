part of 'home_visit_areas_cubit.dart';

sealed class HomeVisitAreasState extends Equatable {
  const HomeVisitAreasState();

  @override
  List<Object?> get props => [];
}

final class HomeVisitAreasInitial extends HomeVisitAreasState {
  const HomeVisitAreasInitial();
}

final class HomeVisitAreasLoading extends HomeVisitAreasState {
  const HomeVisitAreasLoading();
}

final class HomeVisitAreasSuccess extends HomeVisitAreasState {
  final List<HomeVisitAreaModel> areas;
  const HomeVisitAreasSuccess(this.areas);

  @override
  List<Object?> get props => [areas];
}

final class HomeVisitAreasError extends HomeVisitAreasState {
  final String message;
  const HomeVisitAreasError(this.message);

  @override
  List<Object?> get props => [message];
}
