import 'package:easy_localization/easy_localization.dart';
import 'package:vivacare_white_label/core/extensions/extensions.dart';
import 'package:vivacare_white_label/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/custom_text_field_phone/custom_text_field_phone_code.dart';
import '../../../core/utils/locale_keys.dart';
import '../logic/auth_cubit.dart';
import 'widgets/auth_header.dart';
import 'widgets/phone_auth_card.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
                    title: LocaleKeys.auth_register.tr(),
                    subtitle: LocaleKeys.auth_registerSubtitle.tr(),
                    phoneController: _phoneCtrl,
                    formKey: _formKey,
                    submitLabel: LocaleKeys.auth_register.tr(),
                    isLoading: isLoading,
                    onSubmit: _submit,
                    onPhoneChanged: (p) => _phoneNumber = p,
                    footer: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AppText(
                            LocaleKeys.auth_alreadyHaveAccount.tr(),
                            fontSize: 14,
                            color: AppColors.mutedColor.themeColor,
                            fontWeight: FontWeight.w500,
                          ),
                          4.width,
                          GestureDetector(
                            onTap: () => Navigator.pop(context),
                            child: AppText(
                              LocaleKeys.auth_signIn.tr(),
                              fontSize: 14,
                              color: AppColors.accentGold.themeColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
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
