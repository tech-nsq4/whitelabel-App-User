import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/screen_header.dart';
import '../data/visits_mock_data.dart';
import 'widgets/clinic_summary_tile.dart';

class VisitsScreen extends StatelessWidget {
  const VisitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clinics = VisitsMockData.clinics;
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            ScreenHeader(
              title: 'زياراتي',
              subtitle: '${clinics.length} عيادات · اختر العيادة',
            ),
            AppCard(
              padding: EdgeInsets.all(13.r),
              color: AppColors.surfaceColor.themeColor,
              borderColor: Colors.transparent,
              margin: EdgeInsets.only(bottom: 16.h),
              child: Row(
                children: [
                  Icon(Icons.info_outline_rounded,
                      size: 17.sp, color: AppColors.primaryColor.themeColor),
                  10.width,
                  Expanded(
                    child: Text(
                      'زياراتك مرتبة حسب العيادة — اضغط العيادة لعرض زياراتك بها.',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondaryColor.themeColor,
                        height: 1.6,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            for (final clinic in clinics)
              ClinicSummaryTile(
                clinic: clinic,
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.visitList,
                  arguments: {'clinic': clinic.name},
                ),
              ),
          ],
        ),
      ),
    );
  }
}
