import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../utils/app_colors.dart';
import 'custom_tap_effect.dart';

/// The white rounded, bordered, softly-shadowed card used everywhere in the
/// design (the `.tile` class) — appointment cards, list groups, grid tiles.
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.borderColor,
    this.margin,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;
  final Color? color;
  final Color? borderColor;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      padding: padding ?? EdgeInsets.all(15.r),
      decoration: BoxDecoration(
        color: color ?? AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: borderColor ?? AppColors.dividerColor.themeColor),
        boxShadow: [
          BoxShadow(
            color:
                AppColors.textPrimaryColor.themeColor.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );

    if (onTap == null) return card;
    return CustomTapEffect(onTap: onTap!, child: card);
  }
}
