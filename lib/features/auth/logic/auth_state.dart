part of 'auth_cubit.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

/// An OTP was just (re)sent successfully — the UI should show
/// [result.message] and move on to / stay on the OTP screen.
final class OtpSent extends AuthState {
  final OtpSentResult result;
  const OtpSent(this.result);

  @override
  List<Object?> get props => [result];
}

final class AuthSuccess extends AuthState {
  final UserModel user;
  const AuthSuccess(this.user);

  @override
  List<Object?> get props => [user];
}

final class AuthError extends AuthState {
  final String message;
  const AuthError(this.message);

  @override
  List<Object?> get props => [message];
}
