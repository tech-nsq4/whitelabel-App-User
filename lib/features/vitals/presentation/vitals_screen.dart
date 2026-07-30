import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_header.dart';

class VitalsScreen extends StatelessWidget {
  const VitalsScreen({super.key});

  static const _stats = [
    ('النبض', '76', 'نبضة/د', 'طبيعي'),
    ('ضغط الدم', '118/79', 'ملم', 'طبيعي'),
    ('السكر', '94', 'mg/dL', 'طبيعي'),
    ('الوزن', '64', 'كجم', 'ثابت'),
  ];

  static const _pulseSeries = [0.6, 0.72, 0.55, 0.8, 0.68, 0.75, 0.64];

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(title: 'المؤشرات الحيوية', subtitle: 'محدثة اليوم'),
            AppCard(
              padding: EdgeInsets.all(13.r),
              color: AppColors.surfaceColor.themeColor,
              borderColor: Colors.transparent,
              margin: EdgeInsets.only(bottom: 16.h),
              child: AppText(
                'هذه القياسات مأخوذة من سجلك في العيادة — تتحدث مع كل زيارة.',
                fontSize: 11,
                color: AppColors.textSecondaryColor.themeColor,
                height: 1.6,
              ),
            ),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
              childAspectRatio: 1.55,
              children: [
                for (final s in _stats)
                  AppCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText(s.$1, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                        6.height,
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.baseline,
                          textBaseline: TextBaseline.alphabetic,
                          children: [
                            Text(s.$2,
                                style: TextStyle(
                                    fontFamily: AppFonts.headingFont,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.textPrimaryColor.themeColor)),
                            4.width,
                            AppText(s.$3, fontSize: 10, color: AppColors.mutedColor.themeColor),
                          ],
                        ),
                        4.height,
                        AppText(s.$4,
                            fontSize: 10, fontWeight: FontWeight.w600, color: primary),
                      ],
                    ),
                  ),
              ],
            ),
            14.height,
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('النبض — آخر 7 أيام',
                      style: TextStyle(
                          fontSize: 10.sp,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                          color: AppColors.mutedColor.themeColor)),
                  12.height,
                  SizedBox(
                    height: 70.h,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        for (final v in _pulseSeries)
                          Expanded(
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 3.w),
                              height: 70.h * v,
                              decoration: BoxDecoration(
                                color: primary.withValues(alpha: 0.85),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                            ),
                          ),
                      ],
                    ),
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
