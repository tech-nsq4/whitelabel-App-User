import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/notification_model.dart';

/// "اليوم 4:15 م" / "أمس 8:40 م" / "12 يونيو · 4:15 م" — relative for
/// today/yesterday, otherwise a plain date, always with the time.
String _relativeDayTimeLabel(DateTime dateTime, String locale) {
  final now = DateTime.now();
  final yesterday = now.subtract(const Duration(days: 1));
  bool isSameDay(DateTime a, DateTime b) => a.year == b.year && a.month == b.month && a.day == b.day;

  final time = DateFormat('h:mm a', locale).format(dateTime);
  if (isSameDay(dateTime, now)) return '${LocaleKeys.common_today.tr()} $time';
  if (isSameDay(dateTime, yesterday)) return '${LocaleKeys.common_yesterday.tr()} $time';
  return '${DateFormat('d MMMM', locale).format(dateTime)} · $time';
}

/// One row on `NotificationsScreen`. [NotificationModel.title]/[.body] are
/// `easy_localization` keys straight from the API — `.tr()` translates them
/// (or shows the raw key untouched if it's ever missing from our files).
class NotificationTile extends StatelessWidget {
  const NotificationTile({super.key, required this.notification, required this.onTap});

  final NotificationModel notification;
  final VoidCallback onTap;

  static final _icons = {
    'booked': AppSvgIcons.calendar,
    'accepted': AppSvgIcons.checkCircle,
    'started': AppSvgIcons.stethoscope,
    'completed': AppSvgIcons.checkCircle,
    'rescheduled': AppSvgIcons.calendar,
    'offer': AppSvgIcons.giftBox,
  };

  String get _icon => _icons[notification.type] ?? AppSvgIcons.bell;

  Color _color() {
    switch (notification.type) {
      case 'accepted':
      case 'completed':
        return AppColors.successColor.themeColor;
      case 'started':
        return AppColors.secondaryColor.themeColor;
      case 'booked':
      case 'rescheduled':
        return AppColors.accentGold.themeColor;
      case 'offer':
        return AppColors.primaryColor.themeColor;
      default:
        return AppColors.mutedColor.themeColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locale = context.locale.languageCode;
    final color = _color();
    final createdAt = notification.createdAt;

    final isUnread = !notification.isRead;

    return AppCard(
      margin: EdgeInsets.only(bottom: 10.h),
      color: isUnread
          ? AppColors.primaryColor.themeColor.withValues(alpha: 0.06)
          : AppColors.cardColor.themeColor,
      borderColor: isUnread ? AppColors.primaryColor.themeColor.withValues(alpha: 0.25) : null,
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13.r),
            ),
            child: Center(
              child: AppSvgIcon(_icon, size: 18.sp, color: color),
            ),
          ),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  notification.title.tr(),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isUnread ? AppColors.textPrimaryColor.themeColor : AppColors.textSecondaryColor.themeColor,
                ),
                4.height,
                AppText(
                  notification.body.tr(),
                  fontSize: 11,
                  color: AppColors.mutedColor.themeColor,
                  height: 1.5,
                ),
                6.height,
                AppText(
                  createdAt == null ? '' : _relativeDayTimeLabel(createdAt, locale),
                  fontSize: 10,
                  color: AppColors.hintColor.themeColor,
                ),
              ],
            ),
          ),
          if (isUnread) ...[
            8.width,
            Container(
              width: 8.r,
              height: 8.r,
              margin: EdgeInsets.only(top: 4.h),
              decoration: BoxDecoration(color: AppColors.primaryColor.themeColor, shape: BoxShape.circle),
            ),
          ],
        ],
      ),
    );
  }
}
