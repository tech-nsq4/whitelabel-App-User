import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/grid_action_tile.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/widgets/screen_header.dart';
import 'widgets/call_997_dialog.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clay = AppColors.errorColor.themeColor;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(title: 'الطوارئ', subtitle: 'مستعدون على مدار الساعة'),
            AppCard(
              padding: EdgeInsets.all(16.r),
              color: AppColors.textPrimaryColor.themeColor,
              borderColor: Colors.transparent,
              margin: EdgeInsets.only(bottom: 20.h),
              onTap: () => showCall997Dialog(context),
              child: Row(
                children: [
                  Container(
                    width: 44.r,
                    height: 44.r,
                    decoration: BoxDecoration(color: clay, borderRadius: BorderRadius.circular(13.r)),
                    child: Center(
                      child: AppSvgIcon(AppSvgIcons.phoneCall, size: 20.sp, color: Colors.white),
                    ),
                  ),
                  14.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText('الاتصال بالخط الأحمر',
                            isHeading: true, fontSize: 15, color: Colors.white),
                        2.height,
                        AppText('للحالات الخطرة على الحياة',
                            fontSize: 11, color: Colors.white.withValues(alpha: 0.6)),
                      ],
                    ),
                  ),
                  Text('997',
                      style: TextStyle(
                          fontFamily: AppFonts.headingFont,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                          color: clay)),
                ],
              ),
            ),
            Row(children: [
              Expanded(child: _stat('12', 'دقيقة انتظار')),
              10.width,
              Expanded(child: _stat('3', 'سيارات متاحة')),
              10.width,
              Expanded(child: _stat('مفتوح', 'الآن')),
            ]),
            20.height,
            Text('الخدمات',
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.4,
                    color: AppColors.mutedColor.themeColor)),
            10.height,
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
              childAspectRatio: 1.05,
              children: [
                GridActionTile(
                  icon: AppSvgIcons.ambulanceAlt,
                  label: 'طلب سيارة إسعاف',
                  subLabel: 'سيارة إلى موقعك',
                  iconColor: clay,
                  onTap: () => Navigator.pushNamed(context, Routes.emAmbulance),
                ),
                GridActionTile(
                  icon: AppSvgIcons.mapPin,
                  label: 'أقرب طوارئ',
                  subLabel: 'حسب المسافة والانتظار',
                  iconColor: clay,
                  onTap: () => Navigator.pushNamed(context, Routes.emNearest),
                ),
                GridActionTile(
                  icon: AppSvgIcons.stethoscope,
                  label: 'فريق الاستجابة',
                  subLabel: 'رعاية حرجة في منزلك',
                  iconColor: clay,
                  onTap: () => Navigator.pushNamed(context, Routes.emRapid),
                ),
                GridActionTile(
                  icon: AppSvgIcons.clock,
                  label: 'تسجيل حضور مسبق',
                  subLabel: 'سجّل وأنت في الطريق',
                  iconColor: clay,
                  onTap: () => Navigator.pushNamed(context, Routes.emCheckin),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return AppCard(
      child: Column(
        children: [
          Text(value,
              style: TextStyle(
                  fontFamily: AppFonts.headingFont,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor.themeColor)),
          AppText(label, fontSize: 9, color: AppColors.mutedColor.themeColor),
        ],
      ),
    );
  }
}
