import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/list_row_tile.dart';
import '../../../core/widgets/screen_header.dart';
import 'widgets/language_sheet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(title: 'الإعدادات'),
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              margin: EdgeInsets.only(bottom: 16.h),
              child: Column(
                children: [
                  ListRowTile(
                    icon: AppSvgIcons.globe,
                    title: 'اللغة',
                    subtitle: 'العربية',
                    onTap: () => showLanguageSheet(context),
                  ),
                  ListRowTile(
                    icon: AppSvgIcons.settingsGear,
                    title: 'المظهر',
                    subtitle: 'فاتح',
                    onTap: () => ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('فاتح · داكن · تلقائي'))),
                  ),
                  ListRowTile(
                    icon: AppSvgIcons.bell,
                    title: 'التنبيهات',
                    subtitle: 'مفعّلة',
                    showDivider: false,
                    onTap: () => Navigator.pushNamed(context, Routes.notifications),
                  ),
                ],
              ),
            ),
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              margin: EdgeInsets.only(bottom: 16.h),
              child: Column(
                children: [
                  ListRowTile(
                    icon: AppSvgIcons.wallet,
                    title: 'طرق الدفع',
                    subtitle: 'مدى · بطاقة تنتهي بـ 4417',
                    onTap: () => Navigator.pushNamed(context, Routes.payments),
                  ),
                  ListRowTile(
                    icon: AppSvgIcons.vaccine,
                    title: 'التأمين',
                    subtitle: 'بوبا أرابيا · مفعّل',
                    showDivider: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: const Column(
                children: [
                  ListRowTile(title: 'الشروط والأحكام'),
                  ListRowTile(title: 'سياسة الخصوصية', showDivider: false),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
