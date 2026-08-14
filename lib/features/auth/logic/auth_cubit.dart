import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/network_exceptions.dart';
import '../../../core/utils/app_overlay.dart';
import '../data/auth_repo.dart';
import '../data/models/otp_sent_result.dart';
import '../data/models/user_model.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._repo) : super(const AuthInitial());

  final AuthRepo _repo;

  /// Requests an OTP for [phone] — starts both the login and the register
  /// flow, and is also what the OTP screen's resend button calls.
  Future<void> sendOtp(String phone) async {
    emit(const AuthLoading());
    try {
      final result = await _repo.sendOtp(phone: phone);
      emit(OtpSent(result));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      emit(AuthError(msg));
    }
  }

  /// Verifies [otp] for [phone] — logs the user in either way (new account
  /// or returning one) and persists the session.
  Future<void> verifyOtp({required String phone, required String otp}) async {
    emit(const AuthLoading());
    try {
      final user = await _repo.verifyOtp(phone: phone, otp: otp);
      emit(AuthSuccess(user));
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      emit(AuthError(msg));
    }
  }

  Future<void> logout() async {
    try {
      await _repo.logout();
      emit(const AuthInitial());
    } catch (e) {
      final msg = e is NetworkException ? e.message : e.toString();
      AppOverlay.showError(msg);
      emit(AuthError(msg));
    }
  }
}
