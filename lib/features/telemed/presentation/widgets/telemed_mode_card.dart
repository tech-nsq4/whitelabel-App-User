import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

/// One of the two consultation-mode picks ("scheduled" / "instant") shown
/// above the specialty list — a selectable card with a leading icon, a
/// title + subtitle, and the price for that mode.
class TelemedModeCard extends StatelessWidget {
  const TelemedModeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.selected,
    this.onTap,
  });

  final String icon;
  final String title;
  final String subtitle;
  final String price;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final fg = selected ? Colors.white : AppColors.textPrimaryColor.themeColor;
    final muted =
        selected ? Colors.white.withValues(alpha: 0.72) : AppColors.mutedColor.themeColor;
    final priceColor = selected ? Colors.white : primary;

    return CustomTapEffect(
      onTap: onTap ?? () {},
      isClickable: onTap != null,
      child: Container(
        padding: EdgeInsets.all(14.r),
        decoration: BoxDecoration(
          color: selected ? primary : AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(18.r),
          border: selected
              ? null
              : Border.all(color: AppColors.dividerColor.themeColor),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: AlignmentDirectional.topStart,
              child: AppSvgIcon(icon, size: 20.sp, color: fg),
            ),
            14.height,
            AppText(title, fontSize: 13.5, fontWeight: FontWeight.w700, color: fg),
            3.height,
            AppText(subtitle, fontSize: 10, color: muted),
            10.height,
            AppText(price,
                fontSize: 13, fontWeight: FontWeight.w700, color: priceColor),
          ],
        ),
      ),
    );
  }
}
