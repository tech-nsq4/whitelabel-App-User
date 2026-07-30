import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/list_row_tile.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../data/models/visit_models.dart';
import '../data/visits_mock_data.dart';

class VisitDetailScreen extends StatelessWidget {
  const VisitDetailScreen({super.key, required this.clinic, required this.visitId});

  final String clinic;
  final String visitId;

  @override
  Widget build(BuildContext context) {
    final visits = VisitsMockData.byClinic[clinic] ?? const <VisitModel>[];
    final visit = visits.firstWhere(
      (v) => v.id == visitId,
      orElse: () => visits.isNotEmpty
          ? visits.first
          : VisitModel(
              id: visitId,
              date: '',
              doctor: '',
              branch: clinic,
              type: clinic,
              status: '',
              diagnosis: '—',
            ),
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            ScreenHeader(title: visit.date, subtitle: '${visit.doctor} · $clinic'),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: AppText(
                                visit.type,
                                isHeading: true,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            AppChip(
                              label: visit.status,
                              background: Colors.white.withValues(alpha: 0.16),
                              color: Colors.white,
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        AppText(
                          '${visit.id} · ${visit.branch}',
                          fontSize: 10.5,
                          color: Colors.white.withValues(alpha: 0.5),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(16.r),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'التشخيص',
                          style: TextStyle(
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1.2,
                            color: AppColors.mutedColor.themeColor,
                          ),
                        ),
                        SizedBox(height: 6.h),
                        AppText(
                          visit.diagnosis,
                          fontSize: 12.5,
                          color: AppColors.textPrimaryColor.themeColor,
                          height: 1.8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Text(
              'ما نتج عن هذه الزيارة',
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.2,
                color: AppColors.mutedColor.themeColor,
              ),
            ),
            SizedBox(height: 10.h),
            if (visit.items.isEmpty)
              AppCard(
                margin: EdgeInsets.only(bottom: 14.h),
                child: Center(
                  child: AppText(
                    'لا يوجد ملحقات لهذه الزيارة',
                    fontSize: 11.5,
                    color: AppColors.mutedColor.themeColor,
                  ),
                ),
              )
            else
              AppCard(
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                margin: EdgeInsets.only(bottom: 14.h),
                child: Column(
                  children: [
                    for (var i = 0; i < visit.items.length; i++)
                      ListRowTile(
                        icon: visit.items[i].icon,
                        title: visit.items[i].title,
                        subtitle: visit.items[i].subtitle,
                        showDivider: i != visit.items.length - 1,
                        trailing: AppChip(
                          label: visit.items[i].status,
                          background: visitItemStatusColor(
                                  visit.items[i].statusKind)
                              .withValues(alpha: 0.12),
                          color: visitItemStatusColor(visit.items[i].statusKind),
                        ),
                        onTap: () => _openItem(context, visit.items[i]),
                      ),
                  ],
                ),
              ),
            Row(
              children: [
                Expanded(
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.primaryColor.themeColor,
                      padding: EdgeInsets.symmetric(vertical: 13.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r)),
                    ),
                    onPressed: () => Navigator.pushNamed(context, Routes.book),
                    child: AppText('احجز متابعة',
                        isHeading: true, color: Colors.white, fontSize: 13),
                  ),
                ),
                SizedBox(width: 8.w),
                Container(
                  decoration: BoxDecoration(
                    color: AppColors.surfaceColor.themeColor,
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: IconButton(
                    onPressed: () {},
                    icon: AppSvgIcon(AppSvgIcons.document,
                        size: 18.sp, color: AppColors.primaryColor.themeColor),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _openItem(BuildContext context, VisitItemModel item) {
    if (item.icon == AppSvgIcons.pill) {
      Navigator.pushNamed(context, Routes.phClinics);
    } else if (item.icon == AppSvgIcons.xray) {
      Navigator.pushNamed(context, Routes.xrayClinics);
    } else if (item.icon == AppSvgIcons.flask) {
      Navigator.pushNamed(context, Routes.labClinics);
    }
  }
}
