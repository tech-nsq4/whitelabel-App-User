import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/list_row_tile.dart';
import '../../../core/widgets/screen_header.dart';

class BranchesScreen extends StatelessWidget {
  const BranchesScreen({super.key});

  static const _branches = [
    ('العلا — الفرع الرئيسي', 'طريق الملك فهد · 2.3 كم', true),
    ('المرجس', 'شارع الأمير محمد · 5.8 كم', false),
    ('الماسين', 'طريق أنس بن مالك · 9.1 كم', false),
  ];

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(title: 'فروعنا', subtitle: 'ثلاثة فروع في الرياض'),
            for (final b in _branches)
              AppCard(
                margin: EdgeInsets.only(bottom: 10.h),
                borderColor: b.$3 ? primary.withValues(alpha: 0.6) : null,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.location_on_rounded, color: primary, size: 20.sp),
                      10.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(b.$1,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimaryColor.themeColor),
                            2.height,
                            AppText(b.$2, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                          ],
                        ),
                      ),
                      if (b.$3) AppChip(label: 'المفضل'),
                    ]),
                    10.height,
                    CustomButton(
                        title: 'الاتجاهات',
                        isOutlined: true,
                        height: 36,
                        fontSize: 11.5,
                        onTap: () => ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('فتح الاتجاهات')))),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
