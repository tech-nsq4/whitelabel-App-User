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

class AiPlanScreen extends StatefulWidget {
  const AiPlanScreen({super.key});

  @override
  State<AiPlanScreen> createState() => _AiPlanScreenState();
}

class _AiPlanScreenState extends State<AiPlanScreen> {
  bool _yearly = true;

  Future<void> _subscribe() async {
    final paid = await showPaymentSheet(
      context,
      title: _yearly ? 'اشتراك سنوي · المساعد الذكي' : 'اشتراك شهري · المساعد الذكي',
      detail: _yearly ? 'تجديد سنوي · يمكن الإلغاء' : 'تجديد شهري · يمكن الإلغاء',
      amountLabel: _yearly ? '290 ريال' : '29 ريال',
    );
    if (paid != true || !mounted) return;
    await showDialog(
      context: context,
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.r)),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 26.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.auto_awesome_rounded, color: AppColors.primaryColor.themeColor, size: 40.sp),
              14.height,
              AppText('تم الاشتراك!',
                  isHeading: true,
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimaryColor.themeColor),
              8.height,
              AppText(_yearly ? '290 ريال سنويًا' : '29 ريال شهريًا',
                  fontSize: 12, color: AppColors.mutedColor.themeColor),
              18.height,
              CustomButton(title: 'ابدأ استخدام المساعد', onTap: () => Navigator.of(context).pop()),
            ],
          ),
        ),
      ),
    );
    if (!mounted) return;
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(title: 'اشترك في المساعد', subtitle: 'اسأل بلا حدود'),
            AppCard(
              padding: EdgeInsets.all(16.r),
              margin: EdgeInsets.only(bottom: 18.h),
              onTap: () => setState(() => _yearly = false),
              borderColor: !_yearly ? primary : null,
              child: Row(
                children: [
                  Icon(!_yearly ? Icons.radio_button_checked : Icons.radio_button_off,
                      color: !_yearly ? primary : AppColors.hintColor.themeColor),
                  10.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText('شهري', fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimaryColor.themeColor),
                        2.height,
                        AppText('أسئلة غير محدودة', fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                      ],
                    ),
                  ),
                  Text('29 ريال/شهر',
                      style: TextStyle(
                          fontFamily: AppFonts.headingFont,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: primary)),
                ],
              ),
            ),
            AppCard(
              padding: EdgeInsets.all(16.r),
              margin: EdgeInsets.only(bottom: 20.h),
              onTap: () => setState(() => _yearly = true),
              color: _yearly ? primary.withValues(alpha: 0.06) : null,
              borderColor: _yearly ? primary : null,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(_yearly ? Icons.radio_button_checked : Icons.radio_button_off,
                          color: _yearly ? primary : AppColors.hintColor.themeColor),
                      10.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              AppText('سنوي', fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.textPrimaryColor.themeColor),
                              6.width,
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 7.w, vertical: 2.h),
                                decoration: BoxDecoration(
                                    color: AppColors.accentGold.themeColor, borderRadius: BorderRadius.circular(99)),
                                child: const Text('الأفضل قيمة',
                                    style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.w700)),
                              ),
                            ]),
                            2.height,
                            AppText('وفر 58 ريال — شهرين مجانًا', fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                          ],
                        ),
                      ),
                      Text('290 ريال/سنة',
                          style: TextStyle(
                              fontFamily: AppFonts.headingFont,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: primary)),
                    ],
                  ),
                ],
              ),
            ),
            for (final f in const [
              'أسئلة غير محدودة عن نتائجك وتقاريرك',
              'شرح مبسط بالعربية لا مصطلحات طبية',
              'وصول فوري لملفك الطبي',
              'إلغاء في أي وقت من إعدادات الحساب',
            ])
              Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    Icon(Icons.check_circle_rounded, color: primary, size: 16.sp),
                    8.width,
                    Expanded(
                      child: AppText(f, fontSize: 11.5, color: AppColors.textSecondaryColor.themeColor),
                    ),
                  ],
                ),
              ),
            22.height,
            CustomButton(title: 'اشترك الآن', onTap: _subscribe),
          ],
        ),
      ),
    );
  }
}
