import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:vivacare_white_label/core/extensions/extensions.dart';
import 'package:vivacare_white_label/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../profile/logic/profile_cubit.dart';
import '../logic/auth_cubit.dart';
import 'widgets/auth_header.dart';
import 'widgets/otp_input_boxes.dart';
import 'widgets/otp_resend_button.dart';

/// The 4-digit OTP verification step shared by both Login and Register —
/// both flows request a code via the same `/auth/otp` endpoint and land
/// here to confirm it via `/auth/login`.
class OtpScreen extends StatefulWidget {
  const OtpScreen({
    super.key,
    required this.phone,
    this.isNewUser = false,
    this.popOnSuccess = false,
    this.entryRoute,
  });

  final String phone;
  final bool isNewUser;

  /// `true` when this whole login/register flow was pushed on top of an
  /// existing screen instead of being the app's root auth flow (see
  /// `requireGuestLogin`). Changes what a successful verification does:
  /// instead of resetting the stack to the app shell, it unwinds back to
  /// [entryRoute] (the original `LoginScreen` push) to reveal that original
  /// screen again, resolving its pending `Navigator.pushNamed` with `true`
  /// so it can resume its own flow (e.g. re-open the payment sheet) with its
  /// own still-intact local state — never re-entering `LayoutScreen`.
  final bool popOnSuccess;

  /// The `LoginScreen` route to unwind back to on success. Reached via
  /// `popUntil` rather than a fixed number of `pop()` calls because the
  /// stack depth here varies — the guest may have gone straight
  /// Login → Otp, or detoured through Login → Register → Otp first.
  final Route<dynamic>? entryRoute;

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  /// How long the resend button stays disabled after a code is sent.
  static const _resendCooldown = 120;

  final _otpBoxesKey = GlobalKey<OtpInputBoxesState>();

  String _code = '';
  bool _verifying = false;
  bool _resending = false;
  int _secondsLeft = _resendCooldown;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // A code was just sent to get here, so the cooldown starts right away.
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() => _secondsLeft = _resendCooldown);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsLeft <= 1) {
        timer.cancel();
        setState(() => _secondsLeft = 0);
      } else {
        setState(() => _secondsLeft -= 1);
      }
    });
  }

  Future<void> _resend() async {
    if (_secondsLeft > 0 || _resending) return;
    setState(() => _resending = true);
    await context.read<AuthCubit>().sendOtp(widget.phone);
    if (!mounted) return;
    final state = context.read<AuthCubit>().state;
    setState(() => _resending = false);
    if (state is OtpSent) {
      AppOverlay.showSuccess(state.result.message);
      _otpBoxesKey.currentState?.clear();
      _startTimer();
    }
    // Failures already surface their own error banner from the Cubit — the
    // button just stays enabled so the user can try again.
  }

  Future<void> _verify([String? code]) async {
    final otp = code ?? _code;
    if (otp.length != 4) {
      AppOverlay.showError(LocaleKeys.validation_invalidOtp.tr());
      return;
    }
    if (_verifying) return;

    setState(() => _verifying = true);
    await context.read<AuthCubit>().verifyOtp(phone: widget.phone, otp: otp);
    if (!mounted) return;
    final state = context.read<AuthCubit>().state;
    setState(() => _verifying = false);

    if (state is AuthSuccess) {
      // verifyOtp already returns the full profile — seed the cache with it
      // instead of firing an extra GET /profile right after login.
      context.read<ProfileCubit>().setUser(state.user);

      if (widget.popOnSuccess) {
        await _finishResumedFlow(state.user.profileCompleted);
        return;
      }

      Navigator.pushNamedAndRemoveUntil(
        context,
        state.user.profileCompleted
            ? Routes.layoutScreen
            : Routes.completeProfileScreen,
        (_) => false,
      );
    } else {
      _otpBoxesKey.currentState?.clear();
    }
  }

  /// The [popOnSuccess] counterpart of the normal post-login navigation
  /// above: never touches `LayoutScreen`. If the profile still needs
  /// completing, that screen is pushed (not replacing) with the same flag so
  /// it unwinds the same way; either way this ends by unwinding everything
  /// back down to [entryRoute] and popping it too, handing `true` back to
  /// whoever is awaiting that screen's `Navigator.pushNamed` call.
  Future<void> _finishResumedFlow(bool profileCompleted) async {
    if (!profileCompleted) {
      // Untyped for the same reason as `requireGuestLogin`'s push — a typed
      // `pushNamed<bool>` throws against `RouteGenerator`'s untyped routes.
      final completed = await Navigator.pushNamed(
        context,
        Routes.completeProfileScreen,
        arguments: {'popOnSuccess': true},
      );
      // Backed out of completing the profile — stay put rather than forcing
      // the rest of the pop chain, so the guest is left back on the OTP
      // screen instead of getting silently kicked further than they chose.
      if (completed != true || !mounted) return;
    }
    if (!mounted) return;
    final navigator = Navigator.of(context);
    final entry = widget.entryRoute;
    // `popUntil` (rather than a fixed pop count) so this unwinds correctly
    // whether the guest went straight Login → Otp or detoured through
    // Login → Register → Otp first.
    if (entry != null) {
      navigator.popUntil((route) => identical(route, entry));
    } else {
      navigator.pop(); // fallback: just this OTP screen, best-effort.
    }
    navigator.pop(true); // entryRoute (the Login screen) itself.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AuthHeader(),
            Container(
              padding: 16.paddingHorizontal,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.backgroundColor.themeColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  16.height,
                  AppText(
                    LocaleKeys.auth_otpTitle.tr(),
                    isHeading: true,
                    fontSize: 24,
                    color: AppColors.textPrimaryColor.themeColor,
                    fontWeight: FontWeight.w700,
                  ),
                  8.height,
                  AppText(
                    LocaleKeys.auth_otpSubtitle
                        .tr(namedArgs: {'phone': widget.phone}),
                    fontSize: 13,
                    color: AppColors.mutedColor.themeColor,
                    fontWeight: FontWeight.w500,
                  ),
                  4.height,
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: AppText(
                        LocaleKeys.auth_otpChangeNumber.tr(),
                        fontSize: 13,
                        color: AppColors.secondaryColor.themeColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  28.height,
                  OtpInputBoxes(
                    key: _otpBoxesKey,
                    length: 4,
                    onChanged: (v) => setState(() => _code = v),
                    onCompleted: _verify,
                  ),
                  20.height,
                  OtpResendButton(
                    secondsLeft: _secondsLeft,
                    isResending: _resending,
                    onResend: _resend,
                  ),
                  28.height,
                  CustomButton(
                    title: LocaleKeys.auth_otpConfirm.tr(),
                    onTap: () => _verify(),
                    loading: _verifying,
                  ),
                  50.height,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
