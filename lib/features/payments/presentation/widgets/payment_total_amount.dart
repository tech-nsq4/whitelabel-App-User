import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';

class PaymentTotalAmount extends StatelessWidget {
  const PaymentTotalAmount({super.key, required this.amountLabel, this.strikeAmountLabel});

  final String amountLabel;
  final String? strikeAmountLabel;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    final activeSpan = TextSpan(
      text: amountLabel,
      style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w700, color: primary),
    );

    if (strikeAmountLabel == null) {
      return Text.rich(activeSpan);
    }

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            text: '$strikeAmountLabel  ',
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.mutedColor.themeColor,
              decoration: TextDecoration.lineThrough,
            ),
          ),
          activeSpan,
        ],
      ),
    );
  }
}
