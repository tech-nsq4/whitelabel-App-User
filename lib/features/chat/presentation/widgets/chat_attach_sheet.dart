import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

enum ChatAttachAction { camera, gallery, location }

Future<ChatAttachAction?> showChatAttachSheet(BuildContext context) {
  return showModalBottomSheet<ChatAttachAction>(
    context: context,
    backgroundColor: Colors.transparent,
    builder: (_) => const ChatAttachSheet(),
  );
}

class ChatAttachSheet extends StatelessWidget {
  const ChatAttachSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 36.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 18.h),
            decoration: BoxDecoration(
              color: AppColors.hintColor.themeColor,
              borderRadius: BorderRadius.circular(99),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _AttachOption(
                icon: AppSvgIcons.camera,
                label: LocaleKeys.chat_attachCamera.tr(),
                onTap: () => Navigator.pop(context, ChatAttachAction.camera),
              ),
              _AttachOption(
                icon: AppSvgIcons.galleryImage,
                label: LocaleKeys.chat_attachGallery.tr(),
                onTap: () => Navigator.pop(context, ChatAttachAction.gallery),
              ),
              _AttachOption(
                icon: AppSvgIcons.mapPin,
                label: LocaleKeys.chat_attachLocation.tr(),
                onTap: () => Navigator.pop(context, ChatAttachAction.location),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AttachOption extends StatelessWidget {
  const _AttachOption({required this.icon, required this.label, required this.onTap});

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    return CustomTapEffect(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 56.r,
            height: 56.r,
            decoration: BoxDecoration(color: primary.withValues(alpha: 0.1), shape: BoxShape.circle),
            child: Center(child: AppSvgIcon(icon, size: 24.sp, color: primary)),
          ),
          8.height,
          AppText(label, fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.textPrimaryColor.themeColor),
        ],
      ),
    );
  }
}
