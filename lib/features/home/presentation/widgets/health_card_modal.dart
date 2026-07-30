import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import 'health_card_detail.dart';

/// Full-screen presentation of the health card detail, shown when the
/// patient taps their card on the home screen or account tab.
Future<void> showHealthCardModal(BuildContext context) {
  return showDialog(
    context: context,
    barrierColor: AppColors.textPrimaryColor.themeColor.withValues(alpha: 0.65),
    builder: (_) => Dialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 20.w),
      backgroundColor: Colors.transparent,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const HealthCardDetail(),
          16.height,
          CustomButton(
            title: LocaleKeys.home_addToWallet.tr(),
            color: AppColors.textPrimaryColor.themeColor,
            onTap: () {},
          ),
          8.height,
          CustomButton(
            title: LocaleKeys.common_close.tr(),
            color: Colors.white.withValues(alpha: 0.14),
            borderColor: Colors.white.withValues(alpha: 0.18),
            textColor: Colors.white,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    ),
  );
}
