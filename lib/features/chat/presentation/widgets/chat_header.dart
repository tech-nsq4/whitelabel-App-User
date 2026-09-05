import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import '../../../../core/widgets/image/custom_image.dart';
import '../../data/chat_repo.dart';
import '../../data/models/chat_message_model.dart';

class ChatHeader extends StatelessWidget {
  const ChatHeader({
    super.key,
    required this.name,
    required this.image,
    required this.presenceRole,
    required this.presenceId,
  });

  final String name;
  final String? image;
  final ChatSenderRole presenceRole;
  final int presenceId;

  @override
  Widget build(BuildContext context) {
    final hasImage = image != null && image!.isNotEmpty;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        border: Border(bottom: BorderSide(color: AppColors.dividerColor.themeColor)),
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            CustomTapEffect(
              onTap: ()=>Navigator.maybePop(context),
              child: Icon(Icons.arrow_back_ios_new,size: 20,),
            ),
            6.width,
            hasImage
                ? CustomImage(image: image!, width: 40.r, height: 40.r, radius: 12.r)
                : Container(
                    width: 40.r,
                    height: 40.r,
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.themeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      name.trim().isEmpty ? '' : name.trim()[0],
                      style: TextStyle(
                        fontFamily: AppFonts.headingFont,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primaryColor.themeColor,
                      ),
                    ),
                  ),
            12.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    name,
                    isHeading: true,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    color: AppColors.textPrimaryColor.themeColor,
                  ),
                  2.height,
                  StreamBuilder<ChatPresenceModel>(
                    stream: getIt<ChatRepo>().watchPresence(role: presenceRole, id: presenceId),
                    builder: (context, snapshot) {
                      final presence = snapshot.data;
                      return AppText(
                        _presenceLabel(context, presence),
                        fontSize: 11,
                        color: presence?.online ?? false
                            ? AppColors.successColor.themeColor
                            : AppColors.mutedColor.themeColor,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _presenceLabel(BuildContext context, ChatPresenceModel? presence) {
    if (presence == null || (!presence.online && presence.lastSeen == null)) {
      return LocaleKeys.chat_offline.tr();
    }
    if (presence.online) return LocaleKeys.chat_online.tr();

    final lastSeen = presence.lastSeen!;
    final locale = context.locale.languageCode;
    final now = DateTime.now();
    final isToday = lastSeen.year == now.year && lastSeen.month == now.month && lastSeen.day == now.day;
    final time = DateFormat('h:mm a', locale).format(lastSeen);
    if (isToday) {
      return LocaleKeys.chat_lastSeenToday.tr(namedArgs: {'time': time});
    }
    return LocaleKeys.chat_lastSeenDate.tr(namedArgs: {
      'date': DateFormat('d MMMM', locale).format(lastSeen),
      'time': time,
    });
  }
}
