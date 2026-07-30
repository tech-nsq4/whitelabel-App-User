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

/// Greeting + quick-action icon buttons (notifications, health card) shown
/// at the top of the home screen.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    this.notificationCount = 0,
    this.onNotificationsTap,
    this.onCardTap,
  });

  final int notificationCount;
  final VoidCallback? onNotificationsTap;
  final VoidCallback? onCardTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppText(
                LocaleKeys.home_greetingMorning.tr(),
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: AppColors.mutedColor.themeColor,
              ),
              3.height,
              AppText(
                LocaleKeys.home_familyName.tr(),
                isHeading: true,
                fontSize: 19,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryColor.themeColor,
              ),
            ],
          ),
        ),
        9.width,
        _HeaderIconButton(
          icon: AppSvgIcons.bell,
          badgeCount: notificationCount,
          onTap: onNotificationsTap,
        ),
        9.width,
        _HeaderIconButton(icon: AppSvgIcons.card, onTap: onCardTap),
      ],
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({required this.icon, this.badgeCount = 0, this.onTap});

  final String icon;
  final int badgeCount;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomTapEffect(
      onTap: onTap ?? () {},
      isClickable: onTap != null,
      child: Container(
        width: 40.r,
        height: 40.r,
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(18.r),
          border: Border.all(color: AppColors.dividerColor.themeColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimaryColor.themeColor
                  .withValues(alpha: 0.04),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(
              child: AppSvgIcon(
                icon,
                size: 17.sp,
                color: AppColors.textPrimaryColor.themeColor,
              ),
            ),
            if (badgeCount > 0)
              Positioned(
                top: -3,
                left: -3,
                child: Container(
                  constraints: BoxConstraints(minWidth: 17.r, minHeight: 17.r),
                  padding: EdgeInsets.symmetric(horizontal: 3.w),
                  decoration: BoxDecoration(
                    color: AppColors.errorColor.themeColor,
                    borderRadius: BorderRadius.circular(99),
                    border: Border.all(
                        color: AppColors.backgroundColor.themeColor,
                        width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '$badgeCount',
                    style: TextStyle(
                      fontSize: 9.5.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
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
