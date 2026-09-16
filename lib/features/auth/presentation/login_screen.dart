import 'package:easy_localization/easy_localization.dart';
import 'package:viva_connect_user/core/extensions/extensions.dart';
import 'package:viva_connect_user/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/custom_text_field_phone/custom_text_field_phone_code.dart';
import '../../../core/utils/locale_keys.dart';
import '../logic/auth_cubit.dart';
import 'widgets/auth_header.dart';
import 'widgets/dashed_guest_button.dart';
import 'widgets/phone_auth_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, this.popOnSuccess = false});

  /// `true` when this screen was pushed on top of an existing flow (e.g. a
  /// guest hitting [requireGuestLogin] mid-booking) instead of being the
  /// app's root auth screen. See [OtpScreen.popOnSuccess] for what changes
  /// on success.
  final bool popOnSuccess;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _phoneCtrl = TextEditingController();
  PhoneNumber? _phoneNumber;

  @override
  void dispose() {
    _phoneCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    // The backend takes a bare local number (e.g. "01012345678"), not one
    // prefixed with the country's dial code.
    context.read<AuthCubit>().sendOtp(_phoneNumber!.number);
  }

  void _continueAsGuest() {
    // Already browsing as a guest in this case (this screen was pushed from
    // a guest-only gate, not reached as the app's root auth screen) — just
    // back out of the gate instead of resetting to the app shell.
    if (widget.popOnSuccess) {
      Navigator.pop(context, false);
      return;
    }
    Navigator.pushNamedAndRemoveUntil(
      context,
      Routes.layoutScreen,
      (_) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is OtpSent) {
          AppOverlay.showSuccess(state.result.message);
          Navigator.pushNamed(
            context,
            Routes.otpScreen,
            arguments: {
              'phone': state.result.phone,
              'isNewUser': state.result.isNewUser,
              'popOnSuccess': widget.popOnSuccess,
              'entryRoute': widget.popOnSuccess ? ModalRoute.of(context) : null,
            },
          );
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            body: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AuthHeader(),
                  PhoneAuthCard(
                    title: LocaleKeys.auth_login.tr(),
                    subtitle: LocaleKeys.auth_loginSubtitle.tr(),
                    phoneController: _phoneCtrl,
                    formKey: _formKey,
                    submitLabel: LocaleKeys.auth_login.tr(),
                    isLoading: isLoading,
                    onSubmit: _submit,
                    onPhoneChanged: (p) => _phoneNumber = p,
                    footer: Column(
                      children: [
                        // A guest who got here via the booking gate is
                        // already browsing as a guest — offering "continue
                        // as guest" again is just noise, so it's skipped for
                        // that case (see `_continueAsGuest` too).
                        if (!widget.popOnSuccess) ...[
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: AppColors.dividerColor.themeColor,
                                  thickness: 1,
                                  endIndent: 8,
                                ),
                              ),
                              AppText(
                                LocaleKeys.auth_or.tr(),
                                fontSize: 14,
                                color: AppColors.mutedColor.themeColor,
                                fontWeight: FontWeight.w600,
                              ),
                              Expanded(
                                child: Divider(
                                  color: AppColors.dividerColor.themeColor,
                                  thickness: 1,
                                  indent: 8,
                                ),
                              ),
                            ],
                          ),
                          18.height,
                          DashedGuestButton(
                            label: LocaleKeys.auth_continueAsGuest.tr(),
                            color: AppColors.primaryColor.themeColor,
                            onTap: _continueAsGuest,
                          ),
                          20.height,
                        ],
                        Center(
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AppText(
                                LocaleKeys.auth_dontHaveAccount.tr(),
                                fontSize: 14,
                                color: AppColors.mutedColor.themeColor,
                                fontWeight: FontWeight.w500,
                              ),
                              4.width,
                              GestureDetector(
                                onTap: () => Navigator.pushNamed(
                                  context,
                                  Routes.registerScreen,
                                  arguments: {
                                    'popOnSuccess': widget.popOnSuccess,
                                    // The route this whole resumed flow needs
                                    // to unwind back to on success is *this*
                                    // login screen, not wherever Register
                                    // ends up pushed from — forwarded as-is
                                    // through Register → Otp (→
                                    // CompleteProfile) so success can
                                    // `popUntil` straight back to it no
                                    // matter how many screens deep this went.
                                    'entryRoute': widget.popOnSuccess ? ModalRoute.of(context) : null,
                                  },
                                ),
                                child: AppText(
                                  LocaleKeys.auth_register.tr(),
                                  fontSize: 14,
                                  color: AppColors.accentGold.themeColor,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
