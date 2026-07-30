import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/grid_action_tile.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/widgets/screen_header.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(title: 'تواصل معنا', subtitle: 'رد على مدار الساعة'),
            Row(children: [
              Expanded(
                child: GridActionTile(
                  icon: AppSvgIcons.phoneCall,
                  label: 'اتصال',
                  filled: true,
                  onTap: () => ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('جارٍ الاتصال'))),
                ),
              ),
              10.width,
              Expanded(
                child: GridActionTile(
                  icon: AppSvgIcons.chatBubble,
                  label: 'واتساب',
                  onTap: () => ScaffoldMessenger.of(context)
                      .showSnackBar(const SnackBar(content: Text('فتح واتساب'))),
                ),
              ),
              10.width,
              Expanded(
                child: GridActionTile(
                  icon: AppSvgIcons.mapPin,
                  label: 'الفروع',
                  onTap: () => Navigator.pushNamed(context, Routes.branches),
                ),
              ),
            ]),
            18.height,
            AppCard(
              margin: EdgeInsets.only(bottom: 14.h),
              child: Column(
                children: [
                  _row('الهاتف', '+966 11 234 5678'),
                  _row('ساعات العمل', '9 ص – 9 م'),
                  _row('الطوارئ', '24 ساعة'),
                ],
              ),
            ),
            AppCard(
              margin: EdgeInsets.only(bottom: 14.h),
              child: const TextField(
                maxLines: 4,
                decoration: InputDecoration(border: InputBorder.none, hintText: 'اكتب رسالتك'),
              ),
            ),
            CustomButton(
                title: 'إرسال',
                onTap: () => ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('وصلتنا رسالتك — رد خلال ساعات العمل')))),
          ],
        ),
      ),
    );
  }

  Widget _row(String k, String v) {
    return Builder(builder: (context) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 7.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            AppText(k, fontSize: 11.5, color: AppColors.mutedColor.themeColor),
            AppText(v,
                fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimaryColor.themeColor),
          ],
        ),
      );
    });
  }
}
