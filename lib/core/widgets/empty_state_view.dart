import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import 'app_svg_icon.dart';
import 'app_text.dart';

/// Icon circle + title + description — the app's generic "nothing here yet"
/// card, used by any feature's plain list-empty state (no CTA button; pair
/// with one inline at the call site when an action makes sense). Shared
/// across features (`lab`, `medications`, ...) per the "shared widgets go in
/// core" rule — a single-feature empty state can still just build its own.
class EmptyStateView extends StatelessWidget {
  const EmptyStateView({super.key, required this.icon, required this.title, required this.description});

  final String icon;
  final String title;
  final String description;

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
                child: AppSvgIcon(icon, size: 26.sp, color: AppColors.mutedColor.themeColor),
              ),
            ),
            16.height,
            AppText(title,
                isHeading: true,
                fontSize: 15,
                textAlign: TextAlign.center,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryColor.themeColor),
            6.height,
            AppText(description,
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
