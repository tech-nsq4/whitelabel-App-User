import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/list_row_tile.dart';
import '../../../core/widgets/screen_header.dart';
import '../data/models/prescription_model.dart';
import '../data/pharmacy_mock_data.dart';
import 'widgets/refill_sheet.dart';

class PhApptsScreen extends StatelessWidget {
  const PhApptsScreen({super.key, required this.clinic});

  final String clinic;

  @override
  Widget build(BuildContext context) {
    final list = PharmacyMockData.byClinic[clinic] ?? const <PrescriptionModel>[];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            ScreenHeader(title: clinic, subtitle: 'الوصفات الصادرة'),
            for (final rx in list)
              AppCard(
                margin: EdgeInsets.only(bottom: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: AppText(rx.number,
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimaryColor.themeColor),
                        ),
                        AppChip(
                          label: rx.status,
                          background: (rx.isActive
                                  ? AppColors.primaryColor
                                  : AppColors.mutedColor)
                              .themeColor
                              .withValues(alpha: 0.12),
                          color: (rx.isActive
                                  ? AppColors.primaryColor
                                  : AppColors.mutedColor)
                              .themeColor,
                        ),
                      ],
                    ),
                    4.height,
                    AppText('${rx.doctor} · ${rx.date}',
                        fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                    10.height,
                    for (final med in rx.medications)
                      Padding(
                        padding: EdgeInsets.only(bottom: 4.h),
                        child: Row(
                          children: [
                            AppSvgIcon(AppSvgIcons.pill,
                                size: 13.sp, color: AppColors.primaryColor.themeColor),
                            6.width,
                            Expanded(
                              child: AppText(med,
                                  fontSize: 11,
                                  color: AppColors.textSecondaryColor.themeColor),
                            ),
                          ],
                        ),
                      ),
                    if (rx.refillable) ...[
                      8.height,
                      SizedBox(
                        width: double.infinity,
                        child: CustomButton(
                          title: 'اطلب تجديدًا',
                          height: 38,
                          fontSize: 12,
                          onTap: () => showRefillSheet(context, rx),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            if (list.isEmpty)
              AppCard(
                child: Center(
                  child: AppText('لا توجد وصفات مسجلة',
                      color: AppColors.mutedColor.themeColor),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
