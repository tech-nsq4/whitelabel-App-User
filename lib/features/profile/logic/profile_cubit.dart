import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../features/auth/data/auth_repo.dart';
import '../../../features/auth/data/models/user_model.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repo) : super(const ProfileInitial());

  final AuthRepo _repo;

  Future<void> getProfile() async {
    emit(const ProfileLoading());
    try {
      final user = await _repo.getProfile();
      kUserModel = user;
      emit(ProfileSuccess(user));
    } catch (e) {
      // Any profile fetch failure should drop cached user in app-wide guest checks.
      kUserModel = null;
      final msg = e is NetworkException ? e.message : e.toString();
      emit(ProfileError(msg));
    }
  }

  /// Seeds the cache with a [UserModel] already fetched elsewhere (e.g.
  /// right after OTP verification) without an extra network round-trip.
  void setUser(UserModel user) {
    kUserModel = user;
    emit(ProfileSuccess(user));
  }

  /// Completes / updates the profile — used by the "complete your profile"
  /// step shown right after a first login when `profile_completed` is false.
  Future<void> updateProfile({
    required String name,
    String? email,
    String? dateOfBirth,
    double? height,
    double? weight,
  }) async {
    emit(const ProfileLoading());
    try {
      final user = await _repo.updateProfile(
        name: name,
        email: email,
        phone: kUserModel?.phone,
        dateOfBirth: dateOfBirth,
        height: height,
        weight: weight,
      );
      kUserModel = user;
      emit(ProfileSuccess(user));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      emit(ProfileError(msg));
    }
  }

  void reset() {
    kUserModel = null;
    emit(const ProfileInitial());
  }

  /// Registers/refreshes this device's push-notification token — fired
  /// once from the app shell (`LayoutScreen`) for a logged-in user. Silent
  /// and best-effort: it's device housekeeping, not a user action, so a
  /// failure here shouldn't emit an error state or show an overlay.
  Future<void> registerFcmToken(String fcmToken) async {
    try {
      await _repo.updateFcmToken(fcmToken);
    } catch (_) {
      // Ignored on purpose — see doc comment above.
    }
  }

  /// Syncs the app's active UI language with the backend — same
  /// fire-and-forget contract as [registerFcmToken].
  Future<void> syncAppLang(String lang) async {
    try {
      await _repo.updateAppLang(lang);
    } catch (_) {
      // Ignored on purpose — see doc comment above.
    }
  }
}
