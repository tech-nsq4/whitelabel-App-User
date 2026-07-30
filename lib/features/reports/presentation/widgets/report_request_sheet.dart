import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';

Future<void> showReportRequestSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const ReportRequestSheet(),
  );
}

class ReportRequestSheet extends StatefulWidget {
  const ReportRequestSheet({super.key});

  @override
  State<ReportRequestSheet> createState() => _ReportRequestSheetState();
}

class _ReportRequestSheetState extends State<ReportRequestSheet> {
  int _typeIndex = 0;
  final _types = const [
    ('تقرير طبي شامل', 'التاريخ المرضي والزيارات والتحصينات'),
    ('تقرير لجهة التأمين', 'ملخص الحالة والإجراءات والتكاليف'),
    ('شهادة لياقة صحية', 'إثبات خلو من الأمراض للعمل أو السفر'),
  ];

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
          AppText('طلب تقرير طبي',
              isHeading: true,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor.themeColor),
          16.height,
          for (var i = 0; i < _types.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: GestureDetector(
                onTap: () => setState(() => _typeIndex = i),
                child: Container(
                  padding: EdgeInsets.all(13.r),
                  decoration: BoxDecoration(
                    color: _typeIndex == i
                        ? AppColors.primaryColor.themeColor
                        : AppColors.cardColor.themeColor,
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                        color: _typeIndex == i
                            ? Colors.transparent
                            : AppColors.dividerColor.themeColor),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _typeIndex == i
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        size: 18.sp,
                        color: _typeIndex == i
                            ? Colors.white
                            : AppColors.hintColor.themeColor,
                      ),
                      10.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(_types[i].$1,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w600,
                                color: _typeIndex == i
                                    ? Colors.white
                                    : AppColors.textPrimaryColor.themeColor),
                            2.height,
                            AppText(_types[i].$2,
                                fontSize: 10,
                                color: _typeIndex == i
                                    ? Colors.white.withValues(alpha: 0.75)
                                    : AppColors.mutedColor.themeColor),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          20.height,
          CustomButton(
            title: 'أرسل الطلب',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('أُرسل طلب التقرير — جاهز خلال 48 ساعة')),
              );
            },
          ),
        ],
      ),
    );
  }
}
