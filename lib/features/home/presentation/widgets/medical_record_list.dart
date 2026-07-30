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

/// Medical-record shortcuts card: visits, lab results, x-ray, medications.
class MedicalRecordList extends StatelessWidget {
  const MedicalRecordList({
    super.key,
    this.onVisitsTap,
    this.onLabResultsTap,
    this.onXrayTap,
    this.onMedicationsTap,
  });

  final VoidCallback? onVisitsTap;
  final VoidCallback? onLabResultsTap;
  final VoidCallback? onXrayTap;
  final VoidCallback? onMedicationsTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.dividerColor.themeColor),
        boxShadow: [
          BoxShadow(
            color:
                AppColors.textPrimaryColor.themeColor.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _RecordRow(
            icon: AppSvgIcons.medicalFile,
            title: LocaleKeys.home_visits.tr(),
            subtitle: LocaleKeys.home_visitsSubtitle.tr(),
            onTap: onVisitsTap,
          ),
          _RecordRow(
            icon: AppSvgIcons.flask,
            title: LocaleKeys.home_labResults.tr(),
            subtitle: LocaleKeys.home_labResultsSubtitle.tr(),
            iconBg: AppColors.warningColor.themeColor.withValues(alpha: 0.12),
            iconColor: AppColors.warningColor.themeColor,
            badgeText: LocaleKeys.home_labResultsBadge.tr(),
            onTap: onLabResultsTap,
          ),
          _RecordRow(
            icon: AppSvgIcons.xray,
            title: LocaleKeys.home_xray.tr(),
            subtitle: LocaleKeys.home_xraySubtitle.tr(),
            onTap: onXrayTap,
          ),
          _RecordRow(
            icon: AppSvgIcons.pill,
            title: LocaleKeys.home_medications.tr(),
            subtitle: LocaleKeys.home_medicationsSubtitle.tr(),
            isLast: true,
            onTap: onMedicationsTap,
          ),
        ],
      ),
    );
  }
}

class _RecordRow extends StatelessWidget {
  const _RecordRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconBg,
    this.iconColor,
    this.badgeText,
    this.isLast = false,
    this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final Color? iconBg;
  final Color? iconColor;
  final String? badgeText;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return CustomTapEffect(
      onTap: onTap ?? () {},
      isClickable: onTap != null,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h),
        decoration: BoxDecoration(
          border: isLast
              ? null
              : Border(
                  bottom:
                      BorderSide(color: AppColors.dividerColor.themeColor),
                ),
        ),
        child: Row(
          children: [
            Container(
              width: 42.r,
              height: 42.r,
              decoration: BoxDecoration(
                color: iconBg ?? AppColors.surfaceColor.themeColor,
                borderRadius: BorderRadius.circular(13.r),
              ),
              child: Center(
                child: AppSvgIcon(icon,
                    size: 20.sp, color: iconColor ?? primary),
              ),
            ),
            13.width,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor,
                  ),
                  2.height,
                  AppText(
                    subtitle,
                    fontSize: 10.5,
                    color: AppColors.mutedColor.themeColor,
                  ),
                ],
              ),
            ),
            if (badgeText != null)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                decoration: BoxDecoration(
                  color:
                      AppColors.warningColor.themeColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(99),
                ),
                child: Text(
                  badgeText!,
                  style: TextStyle(
                    fontSize: 10.5.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.warningColor.themeColor,
                  ),
                ),
              )
            else
              AppSvgIcon(
                AppSvgIcons.chevronRow,
                size: 17.sp,
                color: AppColors.hintColor.themeColor,
              ),
          ],
        ),
      ),
    );
  }
}
