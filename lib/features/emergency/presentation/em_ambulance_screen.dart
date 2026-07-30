import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_header.dart';

class EmAmbulanceScreen extends StatefulWidget {
  const EmAmbulanceScreen({super.key});

  @override
  State<EmAmbulanceScreen> createState() => _EmAmbulanceScreenState();
}

class _EmAmbulanceScreenState extends State<EmAmbulanceScreen> {
  int _patientIndex = 0;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final clay = AppColors.errorColor.themeColor;
    final patients = const ['نورة (أنا)', 'عبدالله', 'شخص آخر'];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(
                title: 'طلب سيارة إسعاف', subtitle: 'أقرب سيارة تصل خلال ~8 دقائق'),
            AppCard(
              margin: EdgeInsets.only(bottom: 18.h),
              child: Row(
                children: [
                  Icon(Icons.location_on_rounded, color: clay, size: 22.sp),
                  10.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText('حي المرجس — شارع الأمير محمد',
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimaryColor.themeColor),
                        2.height,
                        AppText('محدد تلقائيًا من موقعك',
                            fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                      ],
                    ),
                  ),
                  AppText('تعديل', fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.primaryColor.themeColor),
                ],
              ),
            ),
            Text('المريض',
                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor)),
            10.height,
            Row(
              children: [
                for (var i = 0; i < patients.length; i++)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _patientIndex = i),
                      child: Container(
                        margin: EdgeInsets.only(left: i == patients.length - 1 ? 0 : 8.w),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: _patientIndex == i
                              ? AppColors.primaryColor.themeColor
                              : AppColors.surfaceColor.themeColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(patients[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 11.5.sp,
                                fontWeight: FontWeight.w600,
                                color: _patientIndex == i
                                    ? Colors.white
                                    : AppColors.textSecondaryColor.themeColor)),
                      ),
                    ),
                  ),
              ],
            ),
            18.height,
            AppCard(
              margin: EdgeInsets.only(bottom: 20.h),
              child: TextField(
                controller: _controller,
                maxLines: 3,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  hintText: 'صف الحالة باختصار',
                ),
              ),
            ),
            CustomButton(
              title: 'اطلب الإسعاف الآن',
              color: clay,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('الإسعاف في الطريق — رقم الطلب AMB-217')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
