import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/custom_loading_widget.dart';

class PromoApplyButton extends StatelessWidget {
  const PromoApplyButton({
    super.key,
    required this.loading,
    required this.enabled,
    required this.onTap,
  });

  final bool loading;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    if (loading) {
      return Padding(
        padding: EdgeInsetsDirectional.only(end: 14.w),
        child: Center(
          widthFactor: 1,
          child: CustomLoadingWidget(size: 18, color: primary),
        ),
      );
    }

    return TextButton(
      onPressed: enabled ? onTap : null,
      style: TextButton.styleFrom(
        minimumSize: Size(52.w, 36.h),
        padding: EdgeInsetsDirectional.only(start: 8.w, end: 14.w),
        foregroundColor: primary,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: AppText(
        LocaleKeys.payments_promoApply.tr(),
        fontSize: 12.5,
        fontWeight: FontWeight.w700,
        color: enabled ? primary : AppColors.hintColor.themeColor,
      ),
    );
  }
}
