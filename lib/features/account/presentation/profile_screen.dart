import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/list_row_tile.dart';
import '../../../core/widgets/screen_header.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(title: 'بياناتي'),
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              margin: EdgeInsets.only(bottom: 16.h),
              child: const Column(
                children: [
                  ListRowTile(title: 'الاسم', subtitle: 'أسرة خالد العتيبي', showChevron: false),
                  ListRowTile(title: 'تاريخ الميلاد', subtitle: '15 مارس 1994', showChevron: false),
                  ListRowTile(title: 'الجوال', subtitle: '05X XXX 4417', showChevron: false),
                  ListRowTile(
                      title: 'العنوان', subtitle: 'الرياض · حي المرجس', showChevron: false, showDivider: false),
                ],
              ),
            ),
            Text('المقاسات',
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: AppColors.mutedColor.themeColor)),
            10.height,
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              margin: EdgeInsets.only(bottom: 20.h),
              child: const Column(
                children: [
                  ListRowTile(title: 'الطول', subtitle: '162 سم', showChevron: false),
                  ListRowTile(title: 'الوزن', subtitle: '64 كجم', showChevron: false),
                  ListRowTile(
                      title: 'فصيلة الدم', subtitle: 'O+', showChevron: false, showDivider: false),
                ],
              ),
            ),
            CustomButton(
              title: 'حفظ التعديلات',
              onTap: () => ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(content: Text('تم حفظ بياناتك'))),
            ),
          ],
        ),
      ),
    );
  }
}
