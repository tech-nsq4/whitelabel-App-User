import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/helper_methods.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/section_header.dart';
import '../logic/contact_cubit.dart';
import 'widgets/contact_channels.dart';

class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final ContactCubit _cubit = getIt<ContactCubit>();
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController =
      TextEditingController(text: kUserModel?.name ?? '');
  late final TextEditingController _emailController =
      TextEditingController(text: kUserModel?.email ?? '');
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool _sending = false;

  @override
  void initState() {
    super.initState();
    _cubit.getContactInfo();
  }

  @override
  void dispose() {
    _cubit.close();
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      (value == null || value.trim().isEmpty) ? LocaleKeys.validation_required.tr() : null;

  String? _validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return LocaleKeys.validation_required.tr();
    final emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');
    if (!emailRegex.hasMatch(text)) return LocaleKeys.validation_invalidEmail.tr();
    return null;
  }

  Future<void> _launch(Future<void> Function() action) async {
    try {
      await action();
    } catch (_) {
      AppOverlay.showError(LocaleKeys.error_generic.tr());
    }
  }

  Future<void> _send() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    FocusScope.of(context).unfocus();
    setState(() => _sending = true);

    final ok = await _cubit.sendMessage(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      subject: _subjectController.text.trim(),
      message: _messageController.text.trim(),
    );

    if (!mounted) return;
    setState(() => _sending = false);
    if (ok) {
      AppOverlay.showSuccess(LocaleKeys.contact_messageSent.tr());
      _subjectController.clear();
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            ScreenHeader(
              title: LocaleKeys.contact_title.tr(),
              subtitle: LocaleKeys.contact_subtitle.tr(),
            ),
            BlocBuilder<ContactCubit, ContactState>(
              bloc: _cubit,
              builder: (context, state) {
                final info = state is ContactSuccess ? state.info : null;
                return ContactChannels(
                  info: info,
                  hasError: state is ContactError,
                  onRetry: _cubit.getContactInfo,
                  onCall: (phone) => _launch(() => HelperMethods.openDialer(phone)),
                  onWhatsApp: (number) => _launch(() => HelperMethods.openWhatsApp(number)),
                  onBranches: () => Navigator.pushNamed(context, Routes.branches),
                );
              },
            ),
            22.height,
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SectionHeader(title: LocaleKeys.contact_formTitle.tr()),
                  12.height,
                  CustomTextField(
                    hint: LocaleKeys.contact_name.tr(),
                    controller: _nameController,
                    validator: _required,
                  ),
                  12.height,
                  CustomTextField(
                    hint: LocaleKeys.contact_email.tr(),
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: _validateEmail,
                  ),
                  12.height,
                  CustomTextField(
                    hint: LocaleKeys.contact_subject.tr(),
                    controller: _subjectController,
                    validator: _required,
                  ),
                  12.height,
                  CustomTextField(
                    hint: LocaleKeys.contact_message.tr(),
                    controller: _messageController,
                    maxLines: 5,
                    minLines: 4,
                    validator: _required,
                  ),
                  18.height,
                  CustomButton(
                    title: LocaleKeys.contact_send.tr(),
                    loading: _sending,
                    onTap: _send,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
