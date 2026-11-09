part of 'home_visit_cities_cubit.dart';

sealed class HomeVisitCitiesState extends Equatable {
  const HomeVisitCitiesState();

  @override
  List<Object?> get props => [];
}

final class HomeVisitCitiesInitial extends HomeVisitCitiesState {
  const HomeVisitCitiesInitial();
}

final class HomeVisitCitiesLoading extends HomeVisitCitiesState {
  const HomeVisitCitiesLoading();
}

final class HomeVisitCitiesSuccess extends HomeVisitCitiesState {
  final List<HomeVisitCityModel> cities;
  const HomeVisitCitiesSuccess(this.cities);

  @override
  List<Object?> get props => [cities];
}

final class HomeVisitCitiesError extends HomeVisitCitiesState {
  final String message;
  const HomeVisitCitiesError(this.message);

  @override
  List<Object?> get props => [message];
}
