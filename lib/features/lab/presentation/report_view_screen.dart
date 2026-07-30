import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/list_row_tile.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../data/lab_mock_data.dart';
import '../data/models/clinic_report_model.dart';

class ReportViewScreen extends StatelessWidget {
  const ReportViewScreen({
    super.key,
    required this.type,
    required this.clinic,
    required this.number,
  });

  final ReportType type;
  final String clinic;
  final String number;

  @override
  Widget build(BuildContext context) {
    final data = type == ReportType.lab ? LabMockData.lab : LabMockData.xray;
    final reports = data[clinic] ?? const <ClinicReportModel>[];
    final report = reports.firstWhere((r) => r.number == number,
        orElse: () => reports.first);

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            ScreenHeader(title: report.name, subtitle: '${report.date} · ${report.doctor}'),
            AppCard(
              padding: EdgeInsets.zero,
              margin: EdgeInsets.only(bottom: 14.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: EdgeInsets.all(16.r),
                    decoration: BoxDecoration(
                      color: AppColors.textPrimaryColor.themeColor,
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(18.r)),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: AppText(report.name,
                              isHeading: true,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Colors.white),
                        ),
                        AppChip(
                          label: report.status,
                          background: Colors.white.withValues(alpha: 0.16),
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: AppText(
                      report.body,
                      fontSize: 12.5,
                      color: AppColors.textPrimaryColor.themeColor,
                      height: 1.9,
                    ),
                  ),
                ],
              ),
            ),
            if (report.isReady)
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.primaryColor.themeColor,
                        padding: EdgeInsets.symmetric(vertical: 13.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r)),
                      ),
                      onPressed: () {},
                      icon: AppSvgIcon(AppSvgIcons.document,
                          size: 16.sp, color: Colors.white),
                      label: AppText('تحميل التقرير PDF',
                          isHeading: true, color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              )
            else
              AppCard(
                child: Row(
                  children: [
                    AppSvgIcon(AppSvgIcons.info,
                        size: 17.sp, color: AppColors.warningColor.themeColor),
                    SizedBox(width: 10.w),
                    Expanded(
                      child: AppText(
                        'التقرير قيد المراجعة وسيصلك إشعار فور توفره.',
                        fontSize: 11.5,
                        color: AppColors.textSecondaryColor.themeColor,
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
