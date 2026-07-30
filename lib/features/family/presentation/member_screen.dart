import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/list_row_tile.dart';
import '../data/family_mock_data.dart';

class MemberScreen extends StatelessWidget {
  const MemberScreen({super.key, required this.memberId});

  final String memberId;

  @override
  Widget build(BuildContext context) {
    final member = FamilyMockData.members.firstWhere(
      (m) => m.id == memberId,
      orElse: () => FamilyMockData.members.first,
    );
    final primary = AppColors.primaryColor.themeColor;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            Row(
              children: [
                _backButton(context),
                12.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(member.name,
                          isHeading: true,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryColor.themeColor),
                      2.height,
                      AppText(member.relation, fontSize: 11, color: AppColors.mutedColor.themeColor),
                    ],
                  ),
                ),
                Container(
                  width: 46.r,
                  height: 46.r,
                  decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(15.r)),
                  alignment: Alignment.center,
                  child: Text(member.letter,
                      style: TextStyle(
                          fontFamily: AppFonts.headingFont,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
              ],
            ),
            18.height,
            Row(children: [
              Expanded(child: _stat(member.bloodType, 'الفصيلة')),
              8.width,
              Expanded(child: _stat('${member.visitCount}', 'زيارات')),
              8.width,
              const Expanded(child: SizedBox()),
            ]),
            if (member.hasVaccineDue) ...[
              14.height,
              AppCard(
                color: AppColors.warningColor.themeColor.withValues(alpha: 0.08),
                borderColor: AppColors.warningColor.themeColor.withValues(alpha: 0.35),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Icon(Icons.vaccines_rounded, color: AppColors.warningColor.themeColor, size: 18.sp),
                      8.width,
                      Expanded(
                        child: AppText('تطعيم مستحق',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryColor.themeColor),
                      ),
                    ]),
                    8.height,
                    SizedBox(
                      width: double.infinity,
                      child: CustomButton(
                        title: 'احجز موعد التطعيم',
                        height: 36,
                        fontSize: 11.5,
                        onTap: () => Navigator.pushNamed(context, Routes.book),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            18.height,
            Text('ملفه',
                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor)),
            10.height,
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  ListRowTile(
                    title: 'مواعيده',
                    subtitle: '${member.visitCount} مواعيد سابقة',
                    onTap: () => Navigator.pushNamed(context, Routes.book),
                  ),
                  ListRowTile(
                    title: 'سجله الطبي',
                    subtitle: '${member.visitCount} زيارات · نتائج وتقارير',
                    onTap: () => Navigator.pushNamed(context, Routes.visits),
                  ),
                  ListRowTile(
                    title: 'تطعيماته',
                    subtitle: 'جدول وزارة الصحة',
                    showDivider: false,
                    onTap: () => Navigator.pushNamed(context, Routes.immunity),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _backButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.maybePop(context),
      child: Container(
        width: 38.r,
        height: 38.r,
        decoration: BoxDecoration(
          color: AppColors.cardColor.themeColor,
          borderRadius: BorderRadius.circular(13.r),
          border: Border.all(color: AppColors.dividerColor.themeColor),
        ),
        child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textPrimaryColor.themeColor),
      ),
    );
  }

  Widget _stat(String value, String label) {
    return Builder(builder: (context) {
      return AppCard(
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontFamily: AppFonts.headingFont,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor.themeColor)),
            AppText(label, fontSize: 9, color: AppColors.mutedColor.themeColor),
          ],
        ),
      );
    });
  }
}
