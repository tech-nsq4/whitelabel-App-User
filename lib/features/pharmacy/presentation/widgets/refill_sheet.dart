import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
import '../../data/models/prescription_model.dart';

Future<void> showRefillSheet(BuildContext context, PrescriptionModel rx) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => RefillSheet(rx: rx),
  );
}

class RefillSheet extends StatelessWidget {
  const RefillSheet({super.key, required this.rx});

  final PrescriptionModel rx;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 28.h),
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36.w,
              height: 4.h,
              margin: EdgeInsets.only(bottom: 18.h),
              decoration: BoxDecoration(
                color: AppColors.hintColor.themeColor,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
          ),
          AppText('إعادة صرف الدواء',
              isHeading: true,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor.themeColor),
          4.height,
          AppText(rx.number, fontSize: 11, color: AppColors.mutedColor.themeColor),
          16.height,
          AppText('الأدوية المطلوبة',
              fontSize: 10, fontWeight: FontWeight.w600,
              color: AppColors.mutedColor.themeColor),
          10.height,
          for (final med in rx.medications)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.check_circle,
                      size: 15.sp, color: AppColors.primaryColor.themeColor),
                  8.width,
                  Expanded(
                    child: AppText(med,
                        fontSize: 11.5,
                        color: AppColors.textPrimaryColor.themeColor,
                        height: 1.6),
                  ),
                ],
              ),
            ),
          20.height,
          CustomButton(
            title: 'أرسل الطلب',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('أُرسل طلب إعادة الصرف — سيصلك إشعار عند الجاهزية')),
              );
            },
          ),
        ],
      ),
    );
  }
}
