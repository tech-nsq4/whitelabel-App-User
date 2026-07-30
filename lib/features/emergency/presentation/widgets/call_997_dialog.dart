import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';

Future<void> showCall997Dialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (_) => Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 26.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 62.r,
              height: 62.r,
              decoration: BoxDecoration(
                color: AppColors.errorColor.themeColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.call_rounded, color: AppColors.errorColor.themeColor, size: 28.sp),
            ),
            16.height,
            AppText('الاتصال بالخط الأحمر',
                isHeading: true,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryColor.themeColor),
            8.height,
            AppText('سيتم الاتصال بالرقم 997 — لحالات الخطر على الحياة فقط',
                fontSize: 12,
                textAlign: TextAlign.center,
                color: AppColors.mutedColor.themeColor),
            18.height,
            CustomButton(
              title: 'اتصل الآن',
              color: AppColors.errorColor.themeColor,
              onTap: () => Navigator.pop(context),
            ),
            8.height,
            CustomButton(
              title: 'إلغاء',
              isOutlined: true,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    ),
  );
}
