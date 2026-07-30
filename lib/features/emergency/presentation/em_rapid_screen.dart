import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_header.dart';
import '../../payments/presentation/widgets/payment_sheet.dart';

class EmRapidScreen extends StatelessWidget {
  const EmRapidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final clay = AppColors.errorColor.themeColor;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(title: 'فريق الاستجابة السريعة', subtitle: 'رعاية حرجة في منزلك'),
            AppCard(
              padding: EdgeInsets.all(18.r),
              color: AppColors.textPrimaryColor.themeColor,
              borderColor: Colors.transparent,
              margin: EdgeInsets.only(bottom: 16.h),
              child: Row(
                children: [
                  Container(
                    width: 46.r,
                    height: 46.r,
                    decoration: BoxDecoration(color: clay, borderRadius: BorderRadius.circular(14.r)),
                    child: Icon(Icons.medical_services_rounded, color: Colors.white, size: 22.sp),
                  ),
                  13.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText('طبيب طوارئ + مسعفان',
                            isHeading: true, fontSize: 14, color: Colors.white),
                        3.height,
                        AppText('تجهيزات كاملة · يصل خلال 20 دقيقة',
                            fontSize: 11, color: Colors.white.withValues(alpha: 0.6)),
                      ],
                    ),
                  ),
                  Text('450',
                      style: TextStyle(
                          fontFamily: AppFonts.headingFont,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentGold.themeColor)),
                ],
              ),
            ),
            Text('متى تطلبه',
                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor)),
            10.height,
            for (final c in const ['أزمات قلبية أو صدرية', 'كسور أو سقوط في موقع الحركة', 'تدهور بعد عملية جراحية'])
              AppCard(
                margin: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded, color: clay, size: 16.sp),
                    10.width,
                    Expanded(
                      child: AppText(c,
                          fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.textPrimaryColor.themeColor),
                    ),
                  ],
                ),
              ),
            18.height,
            CustomButton(
              title: 'اطلب الفريق — 450 ريال',
              color: clay,
              onTap: () => showPaymentSheet(context,
                  title: 'فريق الاستجابة السريعة',
                  detail: 'حي المرجس · خلال 20 دقيقة',
                  amountLabel: '450 ريال'),
            ),
          ],
        ),
      ),
    );
  }
}
