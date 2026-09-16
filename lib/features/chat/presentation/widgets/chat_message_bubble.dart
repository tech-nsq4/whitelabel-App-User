import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:photo_view/photo_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../../core/widgets/image/custom_image.dart';
import '../../data/models/chat_message_model.dart';
import 'chat_location_map.dart';

class ChatMessageBubble extends StatelessWidget {
  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMine,
    this.isRead = false,
    this.selectionMode = false,
    this.selected = false,
    this.onTap,
    this.onLongPress,
  });

  final ChatMessageModel message;
  final bool isMine;
  final bool isRead;
  final bool selectionMode;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  @override
  Widget build(BuildContext context) {
    final bubbleColor = isMine ? AppColors.primaryColor.themeColor : AppColors.cardColor.themeColor;
    final textColor = isMine ? Colors.white : AppColors.textPrimaryColor.themeColor;
    final radius = Radius.circular(16.r);

    final bubble = Align(
      alignment: isMine ? AlignmentDirectional.centerEnd : AlignmentDirectional.centerStart,
      child: Container(
        constraints: BoxConstraints(maxWidth: 0.72.sw),
        margin: EdgeInsets.symmetric(vertical: 4.h),
        padding: message.type == ChatMessageType.image || message.type == ChatMessageType.location
            ? EdgeInsets.all(4.r)
            : EdgeInsets.symmetric(horizontal: 13.w, vertical: 9.h),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadiusDirectional.only(
            topStart: radius,
            topEnd: radius,
            bottomStart: isMine ? radius : Radius.zero,
            bottomEnd: isMine ? Radius.zero : radius,
          ),
          border: isMine ? null : Border.all(color: AppColors.dividerColor.themeColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            _content(context, textColor),
            SizedBox(height: 3.h),
            Padding(
              padding: EdgeInsetsDirectional.only(
                end: message.type == ChatMessageType.image || message.type == ChatMessageType.location ? 8.w : 0,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppText(
                    message.createdAt == null ? '' : DateFormat('h:mm a', context.locale.languageCode).format(message.createdAt!),
                    fontSize: 9.5,
                    color: isMine ? Colors.white.withValues(alpha: 0.7) : AppColors.mutedColor.themeColor,
                  ),
                  if (isMine) ...[
                    4.width,
                    AppSvgIcon(
                      isRead ? AppSvgIcons.checkDouble : AppSvgIcons.checkCircle,
                      size: 12.sp,
                      color: isRead ? const Color(0xFF34B7F1) : Colors.white.withValues(alpha: 0.7),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: selectionMode ? onTap : null,
      onLongPress: onLongPress,
      child: Container(
        color: selected
            ? AppColors.primaryColor.themeColor.withValues(alpha: 0.10)
            : Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 2.h),
        child: Row(
          children: [
            if (selectionMode && onLongPress != null) ...[
              SizedBox(width: 6.w),
              Icon(
                selected ? Icons.check_circle_rounded : Icons.circle_outlined,
                size: 22.sp,
                color: selected
                    ? AppColors.primaryColor.themeColor
                    : AppColors.mutedColor.themeColor,
              ),
              SizedBox(width: 8.w),
            ],
            Expanded(child: IgnorePointer(ignoring: selectionMode, child: bubble)),
          ],
        ),
      ),
    );
  }

  Widget _content(BuildContext context, Color textColor) {
    switch (message.type) {
      case ChatMessageType.text:
        return AppText(message.text ?? '', fontSize: 13.5, color: textColor, height: 1.4);

      case ChatMessageType.image:
        final url = message.imageUrl;
        if (url == null || url.isEmpty) return const SizedBox.shrink();
        return CustomTapEffect(
          onTap: () => _openImage(context, url),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13.r),
            child: CustomImage(image: url, width: 180.w, height: 180.w, radius: 13.r),
          ),
        );

      case ChatMessageType.location:
        final lat = message.lat;
        final lng = message.lng;
        if (lat == null || lng == null) return const SizedBox.shrink();
        return CustomTapEffect(
          onTap: () => _openMap(lat, lng),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(13.r),
            child: SizedBox(
              width: 210.w,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: 120.h,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        ChatLocationMap(lat: lat, lng: lng, width: 210.w, height: 120.h),
                        Center(
                          child: Icon(Icons.location_on, color: const Color(0xFFE04141), size: 34.sp),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
                    color: AppColors.cardColor.themeColor,
                    child: Row(
                      children: [
                        AppSvgIcon(AppSvgIcons.mapPin, size: 15.sp, color: AppColors.primaryColor.themeColor),
                        6.width,
                        Expanded(
                          child: AppText(
                            LocaleKeys.chat_locationMessageLabel.tr(),
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryColor.themeColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
    }
  }

  void _openImage(BuildContext context, String url) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          body: SafeArea(
            child: Stack(
              children: [
                PhotoView(imageProvider: NetworkImage(url)),
                PositionedDirectional(
                  top: 8,
                  start: 8,
                  child: CustomTapEffect(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: const BoxDecoration(color: Colors.black45, shape: BoxShape.circle),
                      child: const Icon(Icons.close, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _openMap(double lat, double lng) async {
    final uri = Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');
    if (await canLaunchUrl(uri)) await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
