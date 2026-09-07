import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/app_text.dart';

/// "A discount applies to this doctor" strip shown on [DoctorScreen] when the
/// user arrived via an offer.
class DoctorOfferBanner extends StatelessWidget {
  const DoctorOfferBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 11.h),
      decoration: BoxDecoration(
        color: AppColors.surfaceColor.themeColor,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          AppSvgIcon(AppSvgIcons.giftBox, size: 16.sp, color: primary),
          10.width,
          Expanded(
            child: AppText(
              LocaleKeys.booking_offerOnDoctor.tr(),
              fontSize: 11.5,
              color: AppColors.textSecondaryColor.themeColor,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
