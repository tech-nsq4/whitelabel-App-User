import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/list_row_tile.dart';
import '../../../core/widgets/screen_header.dart';

class ImmunityScreen extends StatelessWidget {
  const ImmunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(title: 'الحساسية والتطعيمات'),
            Text('الحساسية',
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: AppColors.mutedColor.themeColor)),
            10.height,
            AppCard(
              margin: EdgeInsets.only(bottom: 8.h),
              child: Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText('البنسلين',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryColor.themeColor),
                      2.height,
                      AppText('حساسية دوائية',
                          fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                    ],
                  ),
                ),
                AppChip(
                  label: 'شديدة',
                  background: AppColors.errorColor.themeColor.withValues(alpha: 0.1),
                  color: AppColors.errorColor.themeColor,
                ),
              ]),
            ),
            AppCard(
              margin: EdgeInsets.only(bottom: 18.h),
              child: Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText('المكسرات',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryColor.themeColor),
                      2.height,
                      AppText('حساسية غذائية',
                          fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                    ],
                  ),
                ),
                AppChip(
                  label: 'متوسطة',
                  background: AppColors.warningColor.themeColor.withValues(alpha: 0.12),
                  color: AppColors.warningColor.themeColor,
                ),
              ]),
            ),
            Text('التطعيمات',
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: AppColors.mutedColor.themeColor)),
            10.height,
            for (final v in const [
              ('إنفلونزا موسمية', '15 يناير 2026', true),
              ('كوفيد — جرعة معززة', '3 مارس 2025', true),
            ])
              AppCard(
                margin: EdgeInsets.only(bottom: 8.h),
                child: Row(children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(v.$1,
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryColor.themeColor),
                        2.height,
                        AppText(v.$2, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                      ],
                    ),
                  ),
                  AppChip(label: 'مكتمل'),
                ]),
              ),
            AppCard(
              margin: EdgeInsets.only(top: 4.h),
              borderColor: AppColors.warningColor.themeColor.withValues(alpha: 0.4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText('نزاز — جرعة منشطة',
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimaryColor.themeColor),
                          2.height,
                          AppText('مستحقة', fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                        ],
                      ),
                    ),
                    AppChip(
                      label: 'مستحقة',
                      background: AppColors.warningColor.themeColor.withValues(alpha: 0.12),
                      color: AppColors.warningColor.themeColor,
                    ),
                  ]),
                  10.height,
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(title: 'احجز موعد التطعيم', height: 38, fontSize: 12, onTap: () {}),
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
