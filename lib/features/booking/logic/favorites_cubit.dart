import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../data/booking_repo.dart';
import '../data/models/doctor_profile_model.dart';

part 'favorites_state.dart';

class FavoritesCubit extends Cubit<FavoritesState> {
  FavoritesCubit(this._repo) : super(const FavoritesInitial());

  final BookingRepo _repo;

  Future<void> load() async {
    if (kIsGuest) return;
    emit(const FavoritesLoading());
    try {
      final branches = await _repo.getFavoriteBranches();
      emit(FavoritesSuccess(branches));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      emit(FavoritesError(msg));
    }
  }

  bool isFavorite(int clinicId) {
    final s = state;
    return s is FavoritesSuccess && s.contains(clinicId);
  }

  Future<void> toggle(DoctorClinicModel clinic) async {
    final s = state;
    final current = s is FavoritesSuccess ? s.branches : const <DoctorClinicModel>[];
    final wasFavorite = current.any((b) => b.id == clinic.id);

    final optimistic = wasFavorite
        ? current.where((b) => b.id != clinic.id).toList()
        : [...current, clinic];
    emit(FavoritesSuccess(optimistic));

    try {
      if (wasFavorite) {
        await _repo.removeFavoriteBranch(clinic.id);
      } else {
        await _repo.addFavoriteBranch(clinic.id);
      }
    } catch (e) {
      emit(FavoritesSuccess(current));
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
    }
  }
}
