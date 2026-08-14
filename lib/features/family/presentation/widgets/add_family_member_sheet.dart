import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_date_field.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/field_label.dart';
import '../../data/models/family_member_model.dart';
import '../../logic/family_cubit.dart';
import 'existing_medical_files.dart';
import 'medical_files_picker.dart';

/// [cubit] is passed explicitly (not read from context) because a modal
/// bottom sheet is pushed as a sibling route — it doesn't inherit
/// `FamilyScreen`'s locally-scoped `BlocProvider`. Pass [initial] to open
/// the sheet in "edit" mode, prefilled with that member's data.
Future<void> showAddFamilyMemberSheet(
  BuildContext context, {
  required FamilyCubit cubit,
  FamilyMemberModel? initial,
}) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => BlocProvider.value(
      value: cubit,
      child: AddFamilyMemberSheet(initial: initial),
    ),
  );
}

class AddFamilyMemberSheet extends StatefulWidget {
  const AddFamilyMemberSheet({super.key, this.initial});

  /// The member being edited — `null` means "add a new member" instead.
  final FamilyMemberModel? initial;

  @override
  State<AddFamilyMemberSheet> createState() => _AddFamilyMemberSheetState();
}

class _AddFamilyMemberSheetState extends State<AddFamilyMemberSheet> {
  final _formKey = GlobalKey<FormState>();
  late final _nameCtrl = TextEditingController(text: widget.initial?.name ?? '');
  late final _phoneCtrl = TextEditingController(text: widget.initial?.phone ?? '');
  late final _idNumberCtrl = TextEditingController(text: widget.initial?.idNumber ?? '');
  late DateTime? _dateOfBirth =
      widget.initial?.dateOfBirth == null ? null : DateTime.tryParse(widget.initial!.dateOfBirth!);
  List<XFile> _medicalFiles = const [];
  bool _submitting = false;

  bool get _isEditing => widget.initial != null;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _idNumberCtrl.dispose();
    super.dispose();
  }

  String? _validateRequired(String? v) => (v == null || v.trim().isEmpty) ? LocaleKeys.validation_required.tr() : null;

  String? _validatePhone(String? v) {
    final value = v?.trim() ?? '';
    if (value.isEmpty) return LocaleKeys.validation_required.tr();
    if (!RegExp(r'^[0-9]{8,15}$').hasMatch(value)) return LocaleKeys.validation_invalidPhone.tr();
    return null;
  }

  String _isoDate(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_dateOfBirth == null) {
      AppOverlay.showError(LocaleKeys.validation_required.tr());
      return;
    }

    setState(() => _submitting = true);
    final cubit = context.read<FamilyCubit>();
    final name = _nameCtrl.text.trim();
    final dateOfBirth = _isoDate(_dateOfBirth!);
    final phone = _phoneCtrl.text.trim();
    final idNumber = _idNumberCtrl.text.trim();

    final ok = _isEditing
        ? await cubit.updateFamilyMember(
            id: widget.initial!.id,
            name: name,
            dateOfBirth: dateOfBirth,
            phone: phone,
            idNumber: idNumber,
            medicalFiles: _medicalFiles,
          )
        : await cubit.addFamilyMember(
            name: name,
            dateOfBirth: dateOfBirth,
            phone: phone,
            idNumber: idNumber,
            medicalFiles: _medicalFiles,
          );
    if (!mounted) return;
    setState(() => _submitting = false);

    if (ok) {
      AppOverlay.showSuccess(_isEditing ? LocaleKeys.family_updateSuccess.tr() : LocaleKeys.family_addSuccess.tr());
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final existingFiles = widget.initial?.medicalFiles ?? const [];

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
        ),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36.w,
                    height: 4.h,
                    margin: EdgeInsets.only(bottom: 18.h),
                    decoration: BoxDecoration(
                      color: AppColors.hintColor.themeColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
                AppText(
                    _isEditing
                        ? LocaleKeys.family_editMemberSheetTitle.tr()
                        : LocaleKeys.family_addMemberSheetTitle.tr(),
                    isHeading: true,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor),
                4.height,
                AppText(
                    _isEditing
                        ? LocaleKeys.family_editMemberSheetSubtitle.tr()
                        : LocaleKeys.family_addMemberSheetSubtitle.tr(),
                    fontSize: 11.5,
                    color: AppColors.mutedColor.themeColor),
                18.height,
                FieldLabel(text: LocaleKeys.auth_name.tr()),
                8.height,
                CustomTextField(
                  hint: LocaleKeys.auth_name.tr(),
                  controller: _nameCtrl,
                  keyboardType: TextInputType.name,
                  validator: _validateRequired,
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
                FieldLabel(text: LocaleKeys.auth_phone.tr()),
                8.height,
                CustomTextField(
                  hint: LocaleKeys.auth_phone.tr(),
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  validator: _validatePhone,
                ),
                14.height,
                FieldLabel(text: LocaleKeys.family_idNumber.tr()),
                8.height,
                CustomTextField(
                  hint: LocaleKeys.family_idNumber.tr(),
                  controller: _idNumberCtrl,
                  keyboardType: TextInputType.number,
                  validator: _validateRequired,
                ),
                if (existingFiles.isNotEmpty) ...[
                  14.height,
                  FieldLabel(text: LocaleKeys.family_existingFiles.tr()),
                  8.height,
                  ExistingMedicalFiles(urls: existingFiles),
                ],
                14.height,
                FieldLabel(text: LocaleKeys.family_medicalFiles.tr()),
                8.height,
                MedicalFilesPicker(
                  files: _medicalFiles,
                  onChanged: (files) => setState(() => _medicalFiles = files),
                ),
                20.height,
                CustomButton(
                  title: _isEditing ? LocaleKeys.profile_saveChanges.tr() : LocaleKeys.family_addMember.tr(),
                  onTap: _submit,
                  loading: _submitting,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
