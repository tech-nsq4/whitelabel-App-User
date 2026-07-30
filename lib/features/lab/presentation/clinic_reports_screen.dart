import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_header.dart';
import '../data/lab_mock_data.dart';
import '../data/models/clinic_report_model.dart';

/// Clinic picker for lab or x-ray reports — shared by the `/lab-clinics`
/// and `/xray-clinics` routes, distinguished by [type].
class ClinicReportsScreen extends StatelessWidget {
  const ClinicReportsScreen({super.key, required this.type});

  final ReportType type;

  @override
  Widget build(BuildContext context) {
    final data = type == ReportType.lab ? LabMockData.lab : LabMockData.xray;
    final primary = AppColors.primaryColor.themeColor;
    final title = type == ReportType.lab ? 'نتائج التحاليل' : 'تقارير الأشعة';

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            ScreenHeader(title: title, subtitle: 'اختر العيادة'),
            for (final entry in data.entries)
              AppCard(
                margin: EdgeInsets.only(bottom: 10.h),
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.clinicAppts,
                  arguments: {
                    'type': type,
                    'clinic': entry.key,
                  },
                ),
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
                        child: AppSvgIcon(
                          type == ReportType.lab
                              ? AppSvgIcons.flask
                              : AppSvgIcons.xray,
                          size: 19.sp,
                          color: primary,
                        ),
                      ),
                    ),
                    13.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            entry.key,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryColor.themeColor,
                          ),
                          2.height,
                          AppText(
                            'آخر تقرير: ${entry.value.first.date}',
                            fontSize: 10.5,
                            color: AppColors.mutedColor.themeColor,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${entry.value.length}',
                      style: TextStyle(
                        fontFamily: AppFonts.headingFont,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: primary,
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
