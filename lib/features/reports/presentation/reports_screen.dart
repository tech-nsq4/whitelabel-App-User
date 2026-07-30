import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/list_row_tile.dart';
import '../../../core/widgets/screen_header.dart';
import 'widgets/report_request_sheet.dart';
import 'widgets/sick_leave_request_sheet.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(title: 'التقارير والإجازات'),
            Text('الإجازات المرضية',
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: AppColors.mutedColor.themeColor)),
            10.height,
            AppCard(
              margin: EdgeInsets.only(bottom: 14.h),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText('إجازة يومان',
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryColor.themeColor),
                        2.height,
                        AppText('GSL-8841 · 12–13 يونيو',
                            fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                      ],
                    ),
                  ),
                  AppChip(label: 'موثقة صحة'),
                ],
              ),
            ),
            AppCard(
              margin: EdgeInsets.only(bottom: 18.h),
              onTap: () => showSickLeaveRequestSheet(context),
              borderColor: AppColors.primaryColor.themeColor.withValues(alpha: 0.4),
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.add_circle_outline,
                        color: AppColors.primaryColor.themeColor, size: 22.sp),
                    6.height,
                    AppText('اطلب إجازة مرضية',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimaryColor.themeColor),
                  ],
                ),
              ),
            ),
            Text('التقارير الطبية',
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.2,
                    color: AppColors.mutedColor.themeColor)),
            10.height,
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              margin: EdgeInsets.only(bottom: 16.h),
              child: Column(
                children: [
                  ListRowTile(
                    title: 'تقرير طبي شامل',
                    subtitle: '12 يونيو · د. خالد',
                    onTap: () {},
                  ),
                  ListRowTile(
                    title: 'تقرير لشركة التأمين',
                    subtitle: '3 يونيو · موثق',
                    showDivider: false,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            CustomButton(
              title: 'اطلب تقريرًا جديدًا',
              isOutlined: true,
              onTap: () => showReportRequestSheet(context),
            ),
          ],
        ),
      ),
    );
  }
}
