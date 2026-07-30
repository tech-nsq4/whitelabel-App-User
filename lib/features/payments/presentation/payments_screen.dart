import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/list_row_tile.dart';
import '../../../core/widgets/screen_header.dart';
import 'widgets/payment_sheet.dart';

class PaymentsScreen extends StatelessWidget {
  const PaymentsScreen({super.key});

  static const _invoices = [
    ('فحص جدة', 'INV-2214 · 18 يونيو', '180', false),
    ('فحص باطنة', 'INV-2190 · 10 يونيو', '150', true),
    ('باقة تحاليل', 'INV-2101 · 28 يناير', '250', true),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(title: 'المدفوعات'),
            Container(
              padding: EdgeInsets.all(20.r),
              margin: EdgeInsets.only(bottom: 18.h),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.themeColor,
                borderRadius: BorderRadius.circular(22.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('رصيد المحفظة',
                      style: TextStyle(
                          fontSize: 10.sp,
                          letterSpacing: 1.4,
                          fontWeight: FontWeight.w600,
                          color: Colors.white.withValues(alpha: 0.55))),
                  6.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text('240',
                          style: TextStyle(
                              fontFamily: AppFonts.headingFont,
                              fontSize: 28.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white)),
                      4.width,
                      Text('ريال',
                          style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.white.withValues(alpha: 0.7))),
                    ],
                  ),
                  6.height,
                  AppText('240 نقطة ولاء = خصم 24 ريال',
                      fontSize: 10.5, color: AppColors.accentGold.themeColor),
                  14.height,
                  SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white.withValues(alpha: 0.16),
                        padding: EdgeInsets.symmetric(vertical: 11.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r)),
                      ),
                      onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('شحن المحفظة')),
                      ),
                      child: AppText('شحن الرصيد',
                          isHeading: true, color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),
            Text('فواتيري',
                style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1.4,
                    color: AppColors.mutedColor.themeColor)),
            10.height,
            for (final inv in _invoices)
              AppCard(
                margin: EdgeInsets.only(bottom: 10.h),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(inv.$1,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimaryColor.themeColor),
                          2.height,
                          AppText(inv.$2,
                              fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                        ],
                      ),
                    ),
                    if (inv.$4)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(inv.$3,
                              style: TextStyle(
                                  fontFamily: AppFonts.headingFont,
                                  fontSize: 14.sp,
                                  color: AppColors.textPrimaryColor.themeColor)),
                          4.height,
                          AppChip(label: 'مدفوعة'),
                        ],
                      )
                    else
                      SizedBox(
                        width: 96.w,
                        child: CustomButton(
                          title: 'ادفع الآن',
                          height: 36,
                          fontSize: 11.5,
                          onTap: () => showPaymentSheet(
                            context,
                            title: inv.$1,
                            detail: inv.$2,
                            amountLabel: '${inv.$3} ريال',
                          ),
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
