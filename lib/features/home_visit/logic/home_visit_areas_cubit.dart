import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/home_visit_repo.dart';
import '../data/models/home_visit_area_model.dart';

part 'home_visit_areas_state.dart';

class HomeVisitAreasCubit extends Cubit<HomeVisitAreasState> {
  HomeVisitAreasCubit(this._repo) : super(const HomeVisitAreasInitial());

  final HomeVisitRepo _repo;

  int? _latestCityId;

  Future<void> getAreas(int cityId) async {
    _latestCityId = cityId;
    emit(const HomeVisitAreasLoading());
    try {
      final areas = await _repo.getAreas(cityId);
      if (_latestCityId != cityId) return;
      emit(HomeVisitAreasSuccess(areas));
    } catch (e) {
      if (_latestCityId != cityId) return;
      final msg = e is NetworkException ? e.message : e.toString();
      emit(HomeVisitAreasError(msg));
    }
  }

  void reset() {
    _latestCityId = null;
    emit(const HomeVisitAreasInitial());
  }
}
