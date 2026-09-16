import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../data/banners_repo.dart';
import '../data/models/banner_model.dart';

part 'banners_state.dart';

class BannersCubit extends Cubit<BannersState> {
  BannersCubit(this._repo) : super(const BannersInitial());

  final BannersRepo _repo;

  Future<void> getBanners() async {
    emit(const BannersLoading());
    try {
      final banners = await _repo.getBanners();
      emit(BannersSuccess(banners));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(BannersError(msg));
    }
  }
}
