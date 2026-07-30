import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_header.dart';
import '../data/visits_mock_data.dart';

class VisitListScreen extends StatelessWidget {
  const VisitListScreen({super.key, required this.clinic});

  final String clinic;

  @override
  Widget build(BuildContext context) {
    final visits = VisitsMockData.byClinic[clinic] ?? const [];
    final primary = AppColors.primaryColor.themeColor;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            ScreenHeader(
              title: clinic,
              subtitle: '${visits.length} زيارة · اضغط للتفاصيل',
            ),
            for (final visit in visits)
              AppCard(
                margin: EdgeInsets.only(bottom: 10.h),
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.visitDetail,
                  arguments: {'clinic': clinic, 'visitId': visit.id},
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(
                            visit.type,
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryColor.themeColor,
                          ),
                          SizedBox(height: 3.h),
                          AppText(
                            '${visit.doctor} · ${visit.date}',
                            fontSize: 10.5,
                            color: AppColors.mutedColor.themeColor,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '${visit.items.length}',
                      style: TextStyle(
                        fontFamily: AppFonts.headingFont,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: primary,
                      ),
                    ),
                    SizedBox(width: 4.w),
                    AppText('عنصر',
                        fontSize: 9, color: AppColors.mutedColor.themeColor),
                  ],
                ),
              ),
            if (visits.isEmpty)
              AppCard(
                child: Center(
                  child: AppText(
                    'لا توجد زيارات مسجلة بعد',
                    color: AppColors.mutedColor.themeColor,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
