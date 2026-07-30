import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../data/family_mock_data.dart';
import 'widgets/add_family_member_sheet.dart';

class FamilyScreen extends StatelessWidget {
  const FamilyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final members = FamilyMockData.members;
    final primary = AppColors.primaryColor.themeColor;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 110.h),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('العائلة',
                          style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                              color: AppColors.mutedColor.themeColor)),
                      3.height,
                      AppText('${members.length} أفراد',
                          isHeading: true,
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryColor.themeColor),
                    ],
                  ),
                ),
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: AppColors.cardColor.themeColor,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(color: AppColors.dividerColor.themeColor),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => showAddFamilyMemberSheet(context),
                    icon: Icon(Icons.add_rounded, color: primary),
                  ),
                ),
              ],
            ),
            22.height,
            for (final m in members)
              AppCard(
                margin: EdgeInsets.only(bottom: 10.h),
                borderColor: m.isActive ? primary.withValues(alpha: 0.6) : null,
                onTap: () => Navigator.pushNamed(context, Routes.member, arguments: {'id': m.id}),
                child: Row(
                  children: [
                    Container(
                      width: 46.r,
                      height: 46.r,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceColor.themeColor,
                        borderRadius: BorderRadius.circular(15.r),
                      ),
                      alignment: Alignment.center,
                      child: Text(m.letter,
                          style: TextStyle(
                              fontFamily: AppFonts.headingFont,
                              fontSize: 17.sp,
                              fontWeight: FontWeight.w600,
                              color: primary)),
                    ),
                    12.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(m.name,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimaryColor.themeColor),
                          2.height,
                          AppText(m.relation, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                          3.height,
                          AppText(m.statusLabel,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: m.hasVaccineDue
                                  ? AppColors.warningColor.themeColor
                                  : primary),
                        ],
                      ),
                    ),
                    if (m.isActive)
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 4.h),
                        decoration:
                            BoxDecoration(color: primary, borderRadius: BorderRadius.circular(99)),
                        child: const Text('النشط',
                            style: TextStyle(fontSize: 10, color: Colors.white, fontWeight: FontWeight.w600)),
                      ),
                  ],
                ),
              ),
            AppCard(
              onTap: () => showAddFamilyMemberSheet(context),
              borderColor: AppColors.dividerColor.themeColor,
              child: Center(
                child: Column(
                  children: [
                    Icon(Icons.add_rounded, color: AppColors.mutedColor.themeColor, size: 22.sp),
                    6.height,
                    AppText('إضافة فرد',
                        fontSize: 12.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textSecondaryColor.themeColor),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
