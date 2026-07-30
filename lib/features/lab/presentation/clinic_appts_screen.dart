import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/list_row_tile.dart';
import '../../../core/widgets/screen_header.dart';
import '../data/lab_mock_data.dart';
import '../data/models/clinic_report_model.dart';

class ClinicApptsScreen extends StatelessWidget {
  const ClinicApptsScreen({super.key, required this.type, required this.clinic});

  final ReportType type;
  final String clinic;

  @override
  Widget build(BuildContext context) {
    final data = type == ReportType.lab ? LabMockData.lab : LabMockData.xray;
    final reports = data[clinic] ?? const <ClinicReportModel>[];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            ScreenHeader(
              title: clinic,
              subtitle: type == ReportType.lab ? 'نتائج التحاليل' : 'تقارير الأشعة',
            ),
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  for (var i = 0; i < reports.length; i++)
                    ListRowTile(
                      title: reports[i].name,
                      subtitle: '${reports[i].doctor} · ${reports[i].date}',
                      showDivider: i != reports.length - 1,
                      trailing: AppChip(
                        label: reports[i].status,
                        background: (reports[i].isReady
                                ? AppColors.primaryColor
                                : AppColors.warningColor)
                            .themeColor
                            .withValues(alpha: 0.12),
                        color: (reports[i].isReady
                                ? AppColors.primaryColor
                                : AppColors.warningColor)
                            .themeColor,
                      ),
                      onTap: () => Navigator.pushNamed(
                        context,
                        Routes.reportView,
                        arguments: {'type': type, 'clinic': clinic, 'number': reports[i].number},
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
