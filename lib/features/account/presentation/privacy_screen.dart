import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/list_row_tile.dart';
import '../../../core/widgets/screen_header.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(
                title: 'الخصوصية والصلاحيات', subtitle: 'من يستطيع الاطلاع على سجلك'),
            AppCard(
              color: AppColors.surfaceColor.themeColor,
              borderColor: Colors.transparent,
              margin: EdgeInsets.only(bottom: 18.h),
              child: AppText(
                'سجلك الطبي خاص بك. الأفراد المرتبطون يرون فقط ما تسمح به، ويمكنك سحب الصلاحية في أي وقت.',
                fontSize: 11.5,
                color: AppColors.textSecondaryColor.themeColor,
                height: 1.7,
              ),
            ),
            Text('الأفراد المرتبطون',
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: AppColors.mutedColor.themeColor)),
            10.height,
            AppCard(
              margin: EdgeInsets.only(bottom: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                          color: AppColors.surfaceColor.themeColor,
                          borderRadius: BorderRadius.circular(13.r)),
                      alignment: Alignment.center,
                      child: AppText('ع',
                          fontWeight: FontWeight.w700, color: AppColors.primaryColor.themeColor),
                    ),
                    10.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText('عبدالله العتيبي',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimaryColor.themeColor),
                          AppText('الزوج', fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                        ],
                      ),
                    ),
                  ]),
                  12.height,
                  Wrap(spacing: 6.w, runSpacing: 6.h, children: [
                    AppChip(label: 'الحجز فقط'),
                    AppChip(
                        label: 'المواعيد',
                        background: AppColors.surfaceColor.themeColor,
                        color: AppColors.textSecondaryColor.themeColor),
                    AppChip(
                        label: 'الملف الكامل',
                        background: AppColors.surfaceColor.themeColor,
                        color: AppColors.textSecondaryColor.themeColor),
                  ]),
                ],
              ),
            ),
            AppCard(
              child: Row(
                children: [
                  Icon(Icons.lock_outline_rounded, color: AppColors.errorColor.themeColor, size: 17.sp),
                  10.width,
                  Expanded(
                    child: AppText('سحب صلاحيات فرد',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.errorColor.themeColor),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
