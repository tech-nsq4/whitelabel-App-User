import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';

/// Dark "not sure which specialty?" card that opens the symptom checker —
/// shown above the specialty grid on [BookScreen].
class SymptomPromptBanner extends StatelessWidget {
  const SymptomPromptBanner({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: EdgeInsets.all(14.r),
      color: AppColors.textPrimaryColor.themeColor,
      borderColor: Colors.transparent,
      child: Row(
        children: [
          Container(
            width: 40.r,
            height: 40.r,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            alignment: Alignment.center,
            child: AppSvgIcon(AppSvgIcons.sparkle,
                size: 18.sp, color: AppColors.accentGold.themeColor),
          ),
          12.width,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppText(LocaleKeys.booking_symptomPrompt.tr(),
                    isHeading: true, fontSize: 12.5, fontWeight: FontWeight.w600, color: Colors.white),
                3.height,
                AppText(LocaleKeys.booking_symptomPromptSub.tr(),
                    fontSize: 10.5, color: Colors.white.withValues(alpha: 0.6)),
              ],
            ),
          ),
          AppSvgIcon(AppSvgIcons.chevronRow,
              size: 15.sp, color: Colors.white.withValues(alpha: 0.4)),
        ],
      ),
    );
  }
}
