import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

class PromoErrorBanner extends StatelessWidget {
  const PromoErrorBanner({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final error = AppColors.errorColor.themeColor;
    final text = message.trim().isEmpty ? LocaleKeys.payments_promoInvalid.tr() : message;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: error.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(11.r),
        border: Border.all(color: error.withValues(alpha: 0.28)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.error_outline_rounded, size: 16.sp, color: error),
          8.width,
          Expanded(
            child: AppText(
              text,
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: error,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
