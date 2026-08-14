import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/custom_text_field_phone/custom_text_field_phone_code.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/field_label.dart';

/// The white, rounded-top card shared by the Login and Register screens:
/// title + subtitle, the one phone field common to both flows, a submit
/// button, and an optional [footer] slot (guest button, switch-flow link…).
class PhoneAuthCard extends StatelessWidget {
  const PhoneAuthCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.phoneController,
    required this.formKey,
    required this.submitLabel,
    required this.isLoading,
    required this.onSubmit,
    required this.onPhoneChanged,
    this.footer,
  });

  final String title;
  final String subtitle;
  final TextEditingController phoneController;
  final GlobalKey<FormState> formKey;
  final String submitLabel;
  final bool isLoading;
  final VoidCallback onSubmit;

  /// Fires on every keystroke and country change with the current
  /// [PhoneNumber] — the screen keeps the latest value to submit.
  final ValueChanged<PhoneNumber> onPhoneChanged;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
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
              title,
              isHeading: true,
              fontSize: 24,
              color: AppColors.textPrimaryColor.themeColor,
              fontWeight: FontWeight.w700,
            ),
            6.height,
            AppText(
              subtitle,
              fontSize: 13,
              color: AppColors.mutedColor.themeColor,
              fontWeight: FontWeight.w500,
            ),
            20.height,
            FieldLabel(text: LocaleKeys.auth_phone.tr()),
            8.height,
            // Egypt is the only market live right now, so it's the default
            // country — its own "must start with 0" / length rules apply
            // automatically, but the picker still lets a user pick another.
            CustomTextFieldPhoneCode(
              hint: LocaleKeys.auth_phone.tr(),
              controller: phoneController,
              egyptIsInitial: true,
              onChanged: onPhoneChanged,
            ),
            24.height,
            CustomButton(
              title: submitLabel,
              onTap: onSubmit,
              loading: isLoading,
            ),
            if (footer != null) ...[20.height, footer!],
            50.height,
          ],
        ),
      ),
    );
  }
}
