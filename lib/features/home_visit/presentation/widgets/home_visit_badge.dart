import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

class HomeVisitBadge extends StatelessWidget {
  const HomeVisitBadge({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    final color = AppColors.secondaryColor.themeColor;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(99.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.home_rounded, size: 11.sp, color: color),
          4.width,
          Flexible(
            child: AppText(
              label ?? LocaleKeys.homeVisit_title.tr(),
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: color,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
