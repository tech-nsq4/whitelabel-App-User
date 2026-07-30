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

/// Quick-access services grid: book appointment (highlighted), telemed
/// consultation, and emergency.
class HomeServicesGrid extends StatelessWidget {
  const HomeServicesGrid({
    super.key,
    this.onBookTap,
    this.onTelemedTap,
    this.onEmergencyTap,
  });

  final VoidCallback? onBookTap;
  final VoidCallback? onTelemedTap;
  final VoidCallback? onEmergencyTap;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ServiceTile(
            icon: AppSvgIcons.calendar,
            label: LocaleKeys.home_bookAppointment.tr(),
            subLabel: LocaleKeys.home_bookAppointmentSubtitle.tr(),
            filled: true,
            onTap: onBookTap,
          ),
        ),
        10.width,
        Expanded(
          child: _ServiceTile(
            icon: AppSvgIcons.videoCam,
            label: LocaleKeys.home_consultation.tr(),
            subLabel: LocaleKeys.home_consultationSubtitle.tr(),
            iconColor: AppColors.primaryColor.themeColor,
            onTap: onTelemedTap,
          ),
        ),
        10.width,
        Expanded(
          child: _ServiceTile(
            icon: AppSvgIcons.ambulance,
            label: LocaleKeys.home_emergency.tr(),
            subLabel: LocaleKeys.home_emergencySubtitle.tr(),
            iconColor: AppColors.errorColor.themeColor,
            showDot: true,
            onTap: onEmergencyTap,
          ),
        ),
      ],
    );
  }
}

class _ServiceTile extends StatelessWidget {
  const _ServiceTile({
    required this.icon,
    required this.label,
    required this.subLabel,
    this.filled = false,
    this.iconColor,
    this.showDot = false,
    this.onTap,
  });

  final String icon;
  final String label;
  final String subLabel;
  final bool filled;
  final Color? iconColor;
  final bool showDot;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final fg = filled ? Colors.white : (iconColor ?? primary);
    final labelColor =
        filled ? Colors.white : AppColors.textPrimaryColor.themeColor;
    final subColor = filled
        ? Colors.white.withValues(alpha: 0.7)
        : AppColors.mutedColor.themeColor;

    return CustomTapEffect(
      onTap: onTap ?? () {},
      isClickable: onTap != null,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 15.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: filled ? primary : AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(18.r),
          border: filled
              ? null
              : Border.all(color: AppColors.dividerColor.themeColor),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimaryColor.themeColor
                  .withValues(alpha: 0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (showDot)
              Positioned(
                top: 0,
                left: 0,
                child: Container(
                  width: 6.r,
                  height: 6.r,
                  decoration: BoxDecoration(
                    color: AppColors.errorColor.themeColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  AppSvgIcon(icon, size: 26.sp, color: fg),
                  6.height,
                  AppText(
                    label,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: labelColor,
                    textAlign: TextAlign.center,
                  ),
                  2.height,
                  AppText(
                    subLabel,
                    fontSize: 9.5,
                    color: subColor,
                    textAlign: TextAlign.center,
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
