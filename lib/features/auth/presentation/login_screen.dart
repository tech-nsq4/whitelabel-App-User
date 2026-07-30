import 'package:easy_localization/easy_localization.dart';
import 'package:vivacare_white_label/core/extensions/extensions.dart';
import 'package:vivacare_white_label/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../logic/auth_cubit.dart';
import '../../profile/logic/profile_cubit.dart';
import 'widgets/auth_header.dart';
import 'widgets/dashed_guest_button.dart';
import 'widgets/field_label.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    context.read<AuthCubit>().login(
          email: _emailCtrl.text.trim(),
          password: _passwordCtrl.text,
        );
  }

  void _continueAsGuest() {
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
        if (state is AuthSuccess) {
          context.read<ProfileCubit>().getProfile();
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.layoutScreen, (_) => false);
        }
      },
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Scaffold(
            body: Form(
              key: _formKey,
              child: SingleChildScrollView(
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
                            LocaleKeys.auth_login.tr(),
                            isHeading: true,
                            fontSize: 24,
                            color: AppColors.textPrimaryColor.themeColor,
                            fontWeight: FontWeight.w700,
                          ),
                          14.height,
                          FieldLabel(text: LocaleKeys.auth_email.tr()),
                          8.height,
                          CustomTextField(
                            hint: LocaleKeys.auth_email.tr(),
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return LocaleKeys.validation_required.tr();
                              }
                              if (!v.contains('@')) {
                                return LocaleKeys.validation_invalidEmail.tr();
                              }
                              return null;
                            },
                          ),
                          14.height,
                          FieldLabel(text: LocaleKeys.auth_password.tr()),
                          8.height,
                          CustomTextField(
                            hint: LocaleKeys.auth_password.tr(),
                            controller: _passwordCtrl,
                            isPassword: true,
                            validator: (v) {
                              if (v == null || v.isEmpty) {
                                return LocaleKeys.validation_required.tr();
                              }
                              if (v.length < 6) {
                                return LocaleKeys.validation_shortPassword.tr();
                              }
                              return null;
                            },
                          ),
                          12.height,
                          22.height,
                          CustomButton(
                            title: LocaleKeys.auth_login.tr(),
                            onTap: _submit,
                            loading: isLoading,
                          ),
                          18.height,
                          Row(
                            children: [
                              Expanded(
                                child: Divider(
                                  color: AppColors.dividerColor.themeColor,
                                  thickness: 1,
                                  endIndent: 8.w,
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
                                  indent: 8.w,
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
                                      context, Routes.registerScreen),
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
                          50.height,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
