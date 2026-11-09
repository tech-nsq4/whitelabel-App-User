import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/home_visit_repo.dart';
import '../data/models/home_visit_city_model.dart';

part 'home_visit_cities_state.dart';

class HomeVisitCitiesCubit extends Cubit<HomeVisitCitiesState> {
  HomeVisitCitiesCubit(this._repo) : super(const HomeVisitCitiesInitial());

  final HomeVisitRepo _repo;

  Future<void> getCities() async {
    emit(const HomeVisitCitiesLoading());
    try {
      final cities = await _repo.getCities();
      emit(HomeVisitCitiesSuccess(cities));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(HomeVisitCitiesError(msg));
    }
  }
}
