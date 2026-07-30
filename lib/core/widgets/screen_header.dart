import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import '../utils/app_svg_icons.dart';
import 'app_svg_icon.dart';
import 'app_text.dart';
import 'custom_tap_effect.dart';

/// Back button + title (+ optional subtitle / trailing action) shown at the
/// top of nearly every secondary screen in the design.
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.onBack,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: subtitle == null ? 20.h : 18.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomTapEffect(
            onTap: onBack ?? () => Navigator.maybePop(context),
            child: Container(
              width: 38.r,
              height: 38.r,
              decoration: BoxDecoration(
                color: AppColors.cardColor.themeColor,
                borderRadius: BorderRadius.circular(13.r),
                border: Border.all(color: AppColors.dividerColor.themeColor),
              ),
              child: Center(
                child: AppSvgIcon(
                  AppSvgIcons.chevronBack,
                  size: 17.sp,
                  color: AppColors.textPrimaryColor.themeColor,
                ),
              ),
            ),
          ),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(
                  title,
                  isHeading: true,
                  fontSize: 19,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor.themeColor,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  2.height,
                  AppText(
                    subtitle!,
                    fontSize: 11.5,
                    color: AppColors.mutedColor.themeColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}
