import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/list_row_tile.dart';
import '../../../core/widgets/screen_header.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  int _tab = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(title: 'حجز موعد', subtitle: 'اختر الطريقة التي تناسبك'),
            Container(
              padding: EdgeInsets.all(4.r),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor.themeColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Expanded(child: _segment('في العيادة', 0)),
                  Expanded(child: _segment('بالفيديو', 1)),
                ],
              ),
            ),
            20.height,
            Text('ابحث عن موعدك',
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: AppColors.mutedColor.themeColor)),
            10.height,
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              margin: EdgeInsets.only(bottom: 18.h),
              child: Column(
                children: [
                  ListRowTile(
                    icon: AppSvgIcons.stethoscope,
                    title: 'حسب التخصص',
                    subtitle: 'باطنة · جلدية · أسنان · أطفال',
                    onTap: () => Navigator.pushNamed(context, Routes.specs),
                  ),
                  ListRowTile(
                    icon: AppSvgIcons.mapPin,
                    title: 'حسب الفرع',
                    subtitle: 'العلا · المرجس · الماسين',
                    showDivider: false,
                    onTap: () => Navigator.pushNamed(context, Routes.specs),
                  ),
                ],
              ),
            ),
            AppCard(
              padding: EdgeInsets.all(16.r),
              color: AppColors.textPrimaryColor.themeColor,
              borderColor: Colors.transparent,
              onTap: () => Navigator.pushNamed(context, Routes.symptomChecker),
              child: Row(
                children: [
                  Container(
                    width: 42.r,
                    height: 42.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(13.r),
                    ),
                    child: Center(
                      child: Icon(Icons.auto_awesome_rounded,
                          color: AppColors.accentGold.themeColor, size: 20.sp),
                    ),
                  ),
                  13.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText('لست متأكدًا من التخصص؟',
                            isHeading: true, fontSize: 13.5, color: Colors.white),
                        3.height,
                        AppText('صف أعراضك ونرشدك للطبيب المناسب',
                            fontSize: 11, color: Colors.white.withValues(alpha: 0.6)),
                      ],
                    ),
                  ),
                  AppSvgIcon(AppSvgIcons.chevronRow,
                      size: 16.sp, color: Colors.white.withValues(alpha: 0.45)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _segment(String label, int index) {
    final active = _tab == index;
    return GestureDetector(
      onTap: () {
        setState(() => _tab = index);
        if (index == 1) Navigator.pushNamed(context, Routes.telemed);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: active ? AppColors.cardColor.themeColor : Colors.transparent,
          borderRadius: BorderRadius.circular(11.r),
          boxShadow: active
              ? [
                  BoxShadow(
                      color: AppColors.textPrimaryColor.themeColor.withValues(alpha: 0.06),
                      blurRadius: 6)
                ]
              : null,
        ),
        child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 12.5.sp,
                fontWeight: active ? FontWeight.w600 : FontWeight.w500,
                color: active
                    ? AppColors.textPrimaryColor.themeColor
                    : AppColors.mutedColor.themeColor)),
      ),
    );
  }
}
