import 'package:equatable/equatable.dart';

/// Result of a successful `POST /auth/otp` call — an OTP has just been sent
/// to [phone]. [isNewUser] tells the caller whether verifying it will
/// register a brand-new account or sign an existing one back in, and
/// [message] is the human-readable text returned by the API to show the user.
class OtpSentResult extends Equatable {
  const OtpSentResult({
    required this.phone,
    required this.isNewUser,
    required this.message,
  });

  final String phone;
  final bool isNewUser;
  final String message;

  @override
  List<Object?> get props => [phone, isNewUser, message];
}
