import 'dart:io';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/location_helper.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/custom_loading_widget.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import 'chat_attach_sheet.dart';

class ChatInputBar extends StatefulWidget {
  const ChatInputBar({
    super.key,
    required this.onSendText,
    required this.onSendImage,
    required this.onSendLocation,
  });

  final ValueChanged<String> onSendText;
  final Future<void> Function(File file) onSendImage;
  final Future<void> Function(double lat, double lng) onSendLocation;

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar> {
  final _controller = TextEditingController();
  bool _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submitText() {
    if (_busy) return;
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    widget.onSendText(text);
    _controller.clear();
  }

  Future<void> _pickAttachment() async {
    final action = await showChatAttachSheet(context);
    if (action == null || !mounted) return;

    setState(() => _busy = true);
    try {
      switch (action) {
        case ChatAttachAction.camera:
        case ChatAttachAction.gallery:
          final picked = await ImagePicker().pickImage(
            source: action == ChatAttachAction.camera ? ImageSource.camera : ImageSource.gallery,
            imageQuality: 80,
          );
          if (picked != null) await widget.onSendImage(File(picked.path));
        case ChatAttachAction.location:
          final position = await LocationHelper.getCurrentPosition();
          if (position != null) {
            await widget.onSendLocation(position.latitude, position.longitude);
          } else if (mounted) {
            AppOverlay.showError(LocaleKeys.booking_locationUnavailable.tr());
          }
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.w, 10.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        border: Border(top: BorderSide(color: AppColors.dividerColor.themeColor)),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            CustomTapEffect(
              onTap: _busy ? () {} : _pickAttachment,
              isClickable: !_busy,
              child: Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(
                  color: AppColors.surfaceColor.themeColor,
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Center(
                  child: AppSvgIcon(
                    AppSvgIcons.attach,
                    size: 18.sp,
                    color: _busy ? primary.withValues(alpha: 0.4) : primary,
                  ),
                ),
              ),
            ),
            8.width,
            Expanded(
              child: CustomTextField(
                controller: _controller,
                hint: LocaleKeys.chat_inputHint.tr(),
                minLines: 1,
                maxLines: 5,
                borderRadius: 20,
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                onChanged: (_) => setState(() {}),
              ),
            ),
            8.width,
            CustomTapEffect(
              onTap: _submitText,
              isClickable: !_busy && _controller.text.trim().isNotEmpty,
              child: Container(
                width: 40.r,
                height: 40.r,
                decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(13.r)),
                child: Center(
                  child: _busy
                      ? CustomLoadingWidget(size: 18.h, color: Colors.white)
                      : Transform.flip(
                          flipX: Directionality.of(context) == ui.TextDirection.rtl,
                          child: AppSvgIcon(AppSvgIcons.send, size: 18.sp, color: Colors.white),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
