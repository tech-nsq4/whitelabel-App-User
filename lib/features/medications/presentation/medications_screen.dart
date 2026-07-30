import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/list_row_tile.dart';
import '../../../core/widgets/screen_header.dart';

class _ActiveMed {
  const _ActiveMed(this.name, this.schedule, this.nextDose, this.progress);
  final String name;
  final String schedule;
  final String nextDose;
  final double progress;
}

class MedicationsScreen extends StatelessWidget {
  const MedicationsScreen({super.key});

  static const _active = [
    _ActiveMed('أموكسيسيلين 500 ملجم', 'حبسولة 3 مرات يوميًا بعد الأكل · باقي 4 أيام',
        '2:00 م', 0.43),
  ];

  static const _other = [
    ('فيتامين د 5000', 'مرة أسبوعيًا'),
    ('باراسيتامول 500', 'عند الحاجة'),
  ];

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(title: 'أدويتي', subtitle: '3 أدوية نشطة'),
            for (final med in _active)
              AppCard(
                margin: EdgeInsets.only(bottom: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppText(med.name,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimaryColor.themeColor),
                        ),
                        AppChip(label: med.nextDose),
                      ],
                    ),
                    6.height,
                    AppText(med.schedule,
                        fontSize: 11, color: AppColors.mutedColor.themeColor),
                    10.height,
                    ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        value: med.progress,
                        minHeight: 6.h,
                        backgroundColor: AppColors.surfaceColor.themeColor,
                        valueColor: AlwaysStoppedAnimation(primary),
                      ),
                    ),
                    10.height,
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        title: 'سجّل الجرعة',
                        isOutlined: true,
                        height: 36,
                        fontSize: 12,
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم تسجيل الجرعة')),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            for (final m in _other)
              AppCard(
                margin: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  children: [
                    Container(
                      width: 42.r,
                      height: 42.r,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceColor.themeColor,
                        borderRadius: BorderRadius.circular(13.r),
                      ),
                      child: Center(
                        child: AppSvgIcon(AppSvgIcons.vaccine,
                            size: 19.sp, color: primary),
                      ),
                    ),
                    13.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(m.$1,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimaryColor.themeColor),
                          2.height,
                          AppText(m.$2,
                              fontSize: 10.5, color: AppColors.mutedColor.themeColor),
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
