import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import 'app_svg_icon.dart';
import 'app_text.dart';
import 'custom_tap_effect.dart';

/// Square icon + label (+ sub-label) action tile used across the services,
/// emergency, and home-care grids.
class GridActionTile extends StatelessWidget {
  const GridActionTile({
    super.key,
    required this.icon,
    required this.label,
    this.subLabel,
    this.filled = false,
    this.iconColor,
    this.showDot = false,
    this.onTap,
  });

  final String icon;
  final String label;
  final String? subLabel;
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
    final subColor =
        filled ? Colors.white.withValues(alpha: 0.7) : AppColors.mutedColor.themeColor;

    return CustomTapEffect(
      onTap: onTap ?? () {},
      isClickable: onTap != null,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 8.w),
        decoration: BoxDecoration(
          color: filled ? primary : AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(18.r),
          border:
              filled ? null : Border.all(color: AppColors.dividerColor.themeColor),
          boxShadow: [
            BoxShadow(
              color:
                  AppColors.textPrimaryColor.themeColor.withValues(alpha: 0.04),
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
            Column(
              children: [
                AppSvgIcon(icon, size: 24.sp, color: fg),
                9.height,
                AppText(label,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: labelColor,
                    textAlign: TextAlign.center),
                if (subLabel != null) ...[
                  2.height,
                  AppText(subLabel!,
                      fontSize: 9.5, color: subColor, textAlign: TextAlign.center),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
