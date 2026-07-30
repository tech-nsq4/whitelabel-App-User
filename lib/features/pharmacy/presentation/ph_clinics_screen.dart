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
import '../data/pharmacy_mock_data.dart';

class PhClinicsScreen extends StatelessWidget {
  const PhClinicsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final data = PharmacyMockData.byClinic;
    final primary = AppColors.primaryColor.themeColor;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(title: 'الصيدلية', subtitle: 'وصفاتك حسب العيادة'),
            for (final entry in data.entries)
              AppCard(
                margin: EdgeInsets.only(bottom: 10.h),
                onTap: () => Navigator.pushNamed(context, Routes.phAppts,
                    arguments: {'clinic': entry.key}),
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
                        child:
                            AppSvgIcon(AppSvgIcons.pill, size: 19.sp, color: primary),
                      ),
                    ),
                    13.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(entry.key,
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimaryColor.themeColor),
                          2.height,
                          AppText('آخر وصفة: ${entry.value.first.date}',
                              fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                        ],
                      ),
                    ),
                    Text('${entry.value.length}',
                        style: TextStyle(
                            fontFamily: AppFonts.headingFont,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: primary)),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
