import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import '../utils/app_svg_icons.dart';
import 'app_svg_icon.dart';
import 'app_text.dart';
import 'custom_tap_effect.dart';

/// One row inside an [AppCard] group — leading icon box, title + subtitle,
/// and a trailing chevron / chip / custom widget. Matches the design's
/// `.row` pattern used across visits, medical-file, account, settings, etc.
class ListRowTile extends StatelessWidget {
  const ListRowTile({
    super.key,
    this.icon,
    required this.title,
    this.subtitle,
    this.iconBg,
    this.iconColor,
    this.trailing,
    this.showChevron = true,
    this.showDivider = true,
    this.onTap,
  });

  final String? icon;
  final String title;
  final String? subtitle;
  final Color? iconBg;
  final Color? iconColor;
  final Widget? trailing;
  final bool showChevron;
  final bool showDivider;
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
          border: showDivider
              ? Border(
                  bottom:
                      BorderSide(color: AppColors.dividerColor.themeColor),
                )
              : null,
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Container(
                width: 42.r,
                height: 42.r,
                decoration: BoxDecoration(
                  color: iconBg ?? AppColors.surfaceColor.themeColor,
                  borderRadius: BorderRadius.circular(13.r),
                ),
                child: Center(
                  child:
                      AppSvgIcon(icon!, size: 19.sp, color: iconColor ?? primary),
                ),
              ),
              13.width,
            ],
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AppText(
                    title,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (subtitle != null) ...[
                    2.height,
                    AppText(
                      subtitle!,
                      fontSize: 10.5,
                      color: AppColors.mutedColor.themeColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
            if (trailing != null)
              trailing!
            else if (showChevron)
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

/// Small pill chip — status labels, badges ("جديد", "مدفوعة"...).
class AppChip extends StatelessWidget {
  const AppChip({
    super.key,
    required this.label,
    this.background,
    this.color,
  });

  final String label;
  final Color? background;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: background ??
            AppColors.primaryColor.themeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5.sp,
          fontWeight: FontWeight.w600,
          color: color ?? AppColors.primaryColor.themeColor,
        ),
      ),
    );
  }
}
