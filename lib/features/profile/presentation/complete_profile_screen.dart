import 'package:easy_localization/easy_localization.dart';
import 'package:vivacare_white_label/core/extensions/extensions.dart';
import 'package:vivacare_white_label/core/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/field_label.dart';
import '../../../core/widgets/verified_phone_field.dart';
import '../logic/profile_cubit.dart';
import '../../../core/widgets/app_date_field.dart';

/// Shown right after a first login/register when the API reports
/// `profile_completed: false` — collects the rest of the user's basic data.
class CompleteProfileScreen extends StatefulWidget {
  const CompleteProfileScreen({super.key});

  @override
  State<CompleteProfileScreen> createState() => _CompleteProfileScreenState();
}

class _CompleteProfileScreenState extends State<CompleteProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _heightCtrl = TextEditingController();
  final _weightCtrl = TextEditingController();
  late final _phoneCtrl =
      TextEditingController(text: kUserModel?.phone ?? '');
  DateTime? _dateOfBirth;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _phoneCtrl.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    if (v == null || v.trim().isEmpty) {
      return LocaleKeys.validation_required.tr();
    }
    return null;
  }

  String? _validateEmail(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return null; // optional
    if (!value.contains('@')) return LocaleKeys.validation_invalidEmail.tr();
    return null;
  }

  String? _validateNumber(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return null; // optional
    if (double.tryParse(value) == null) {
      return LocaleKeys.validation_invalidNumber.tr();
    }
    return null;
  }

  String _isoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailCtrl.text.trim();
    context.read<ProfileCubit>().updateProfile(
          name: _nameCtrl.text.trim(),
          email: email.isEmpty ? null : email,
          dateOfBirth:
              _dateOfBirth == null ? null : _isoDate(_dateOfBirth!),
          height: double.tryParse(_heightCtrl.text.trim()),
          weight: double.tryParse(_weightCtrl.text.trim()),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          Navigator.pushNamedAndRemoveUntil(
              context, Routes.layoutScreen, (_) => false);
        }
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final isLoading = state is ProfileLoading;

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: 20.paddingHorizontal,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      24.height,
                      Container(
                        width: 72.w,
                        height: 72.w,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primaryColor.themeColor
                              .withValues(alpha: 0.12),
                        ),
                        child: Icon(
                          Icons.person_rounded,
                          color: AppColors.primaryColor.themeColor,
                          size: 36.sp,
                        ),
                      ),
                      16.height,
                      AppText(
                        LocaleKeys.profile_completeTitle.tr(),
                        isHeading: true,
                        fontSize: 22,
                        textAlign: TextAlign.center,
                        color: AppColors.textPrimaryColor.themeColor,
                        fontWeight: FontWeight.w700,
                      ),
                      8.height,
                      AppText(
                        LocaleKeys.profile_completeSubtitle.tr(),
                        fontSize: 13,
                        textAlign: TextAlign.center,
                        color: AppColors.mutedColor.themeColor,
                        fontWeight: FontWeight.w500,
                      ),
                      28.height,

                      FieldLabel(text: LocaleKeys.auth_name.tr()),
                      8.height,
                      CustomTextField(
                        hint: LocaleKeys.auth_name.tr(),
                        controller: _nameCtrl,
                        keyboardType: TextInputType.name,
                        validator: _validateName,
                      ),
                      14.height,

                      FieldLabel(text: LocaleKeys.auth_email.tr()),
                      8.height,
                      CustomTextField(
                        hint: LocaleKeys.auth_email.tr(),
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                      ),
                      14.height,

                      FieldLabel(text: LocaleKeys.auth_phone.tr()),
                      8.height,
                      VerifiedPhoneField(
                        hint: LocaleKeys.auth_phone.tr(),
                        phone: _phoneCtrl.text,
                      ),
                      14.height,

                      FieldLabel(text: LocaleKeys.profile_dateOfBirth.tr()),
                      8.height,
                      AppDateField(
                        hint: LocaleKeys.profile_dateOfBirth.tr(),
                        value: _dateOfBirth,
                        onChanged: (d) => setState(() => _dateOfBirth = d),
                      ),
                      14.height,

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FieldLabel(text: LocaleKeys.profile_height.tr()),
                                8.height,
                                CustomTextField(
                                  hint: LocaleKeys.profile_height.tr(),
                                  controller: _heightCtrl,
                                  keyboardType: const TextInputType
                                      .numberWithOptions(decimal: true),
                                  validator: _validateNumber,
                                ),
                              ],
                            ),
                          ),
                          12.width,
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FieldLabel(text: LocaleKeys.profile_weight.tr()),
                                8.height,
                                CustomTextField(
                                  hint: LocaleKeys.profile_weight.tr(),
                                  controller: _weightCtrl,
                                  keyboardType: const TextInputType
                                      .numberWithOptions(decimal: true),
                                  validator: _validateNumber,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      28.height,

                      CustomButton(
                        title: LocaleKeys.profile_saveContinue.tr(),
                        onTap: _submit,
                        loading: isLoading,
                      ),
                      24.height,
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
