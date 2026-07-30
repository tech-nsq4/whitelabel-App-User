import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';

Future<void> showBookingConfirmedDialog(
  BuildContext context, {
  required String doctor,
  required String when,
  required String branch,
}) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 28.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                color: AppColors.surfaceColor.themeColor,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.check_circle_rounded,
                  color: AppColors.primaryColor.themeColor, size: 32.sp),
            ),
            16.height,
            AppText('تم تأكيد موعدك',
                isHeading: true,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryColor.themeColor),
            8.height,
            AppText('$when\n$doctor — $branch',
                textAlign: TextAlign.center,
                fontSize: 12.5,
                color: AppColors.mutedColor.themeColor,
                height: 1.6),
            18.height,
            CustomButton(
              title: 'تمام',
              onTap: () => Navigator.of(context)
                ..pop()
                ..pop(),
            ),
          ],
        ),
      ),
    ),
  );
}
