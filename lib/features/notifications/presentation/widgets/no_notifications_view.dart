import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';

/// Shown on `NotificationsScreen` instead of the list when the account has
/// no notifications yet — mirrors the booking feature's empty-state cards
/// (`NoBookingsView`/`NoSlotsView`).
class NoNotificationsView extends StatelessWidget {
  const NoNotificationsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 36.h, horizontal: 12.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.w,
              height: 64.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.mutedColor.themeColor.withValues(alpha: 0.12),
              ),
              child: Center(
                child: AppSvgIcon(AppSvgIcons.bell, size: 26.sp, color: AppColors.mutedColor.themeColor),
              ),
            ),
            16.height,
            AppText(LocaleKeys.notifications_emptyTitle.tr(),
                isHeading: true,
                fontSize: 15,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryColor.themeColor),
            6.height,
            AppText(LocaleKeys.notifications_emptyDescription.tr(),
                fontSize: 11.5,
                textAlign: TextAlign.center,
                color: AppColors.mutedColor.themeColor,
                height: 1.6),
          ],
        ),
      ),
    );
  }
}
