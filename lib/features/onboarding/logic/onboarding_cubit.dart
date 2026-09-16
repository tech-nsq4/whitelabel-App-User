import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/splash_item_model.dart';
import '../data/onboarding_repo.dart';

part 'onboarding_state.dart';

class OnboardingCubit extends Cubit<OnboardingState> {
  OnboardingCubit(this._repo) : super(const OnboardingInitial());

  final OnboardingRepo _repo;

  Future<void> getSplashes() async {
    emit(const OnboardingLoading());
    try {
      final splashes = await _repo.getSplashes();
      emit(OnboardingSuccess(splashes));
    } catch (e) {
      emit(OnboardingError('$e'));
    }
  }
}
