import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/field_label.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/verified_phone_field.dart';
import '../../profile/logic/profile_cubit.dart';
import '../../../core/widgets/app_date_field.dart';

/// "My data" edit screen (`Routes.profile`) — prefilled from the cached
/// [kUserModel] and saved through the same [ProfileCubit.updateProfile] API
/// used by the first-login completion step.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController(text: kUserModel?.name ?? '');
  late final _emailCtrl = TextEditingController(text: kUserModel?.email ?? '');
  late final _heightCtrl =
      TextEditingController(text: kUserModel?.height?.toString() ?? '');
  late final _weightCtrl =
      TextEditingController(text: kUserModel?.weight?.toString() ?? '');
  late DateTime? _dateOfBirth = _parseDate(kUserModel?.dateOfBirth);

  DateTime? _parseDate(String? iso) => iso == null ? null : DateTime.tryParse(iso);

  String _isoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

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

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final email = _emailCtrl.text.trim();
    context.read<ProfileCubit>().updateProfile(
          name: _nameCtrl.text.trim(),
          email: email.isEmpty ? null : email,
          dateOfBirth: _dateOfBirth == null ? null : _isoDate(_dateOfBirth!),
          height: double.tryParse(_heightCtrl.text.trim()),
          weight: double.tryParse(_weightCtrl.text.trim()),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileSuccess) {
          AppOverlay.showSuccess(LocaleKeys.profile_updateSuccess.tr());
          Navigator.pop(context);
        }
      },
      child: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          final isLoading = state is ProfileLoading;

          return Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ScreenHeader(title: LocaleKeys.profile_title.tr()),

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
                        phone: kUserModel?.phone ?? '',
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
                                  keyboardType:
                                      const TextInputType.numberWithOptions(decimal: true),
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
                                  keyboardType:
                                      const TextInputType.numberWithOptions(decimal: true),
                                  validator: _validateNumber,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      28.height,

                      CustomButton(
                        title: LocaleKeys.profile_saveChanges.tr(),
                        onTap: _submit,
                        loading: isLoading,
                      ),
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
