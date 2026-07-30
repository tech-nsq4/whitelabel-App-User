import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import '../utils/locale_keys.dart';
import 'app_text.dart';

/// Placeholder body for tabs whose real design/API hasn't landed yet.
class ComingSoonView extends StatelessWidget {
  const ComingSoonView({super.key, required this.title, this.icon});

  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? Icons.hourglass_top_rounded,
              size: 40.sp,
              color: AppColors.mutedColor.themeColor,
            ),
            12.height,
            AppText(
              title,
              isHeading: true,
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor.themeColor,
            ),
            6.height,
            AppText(
              LocaleKeys.home_comingSoon.tr(),
              fontSize: 12,
              color: AppColors.mutedColor.themeColor,
            ),
          ],
        ),
      ),
    );
  }
}
