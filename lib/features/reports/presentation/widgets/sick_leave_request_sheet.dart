import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';

Future<void> showSickLeaveRequestSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const SickLeaveRequestSheet(),
  );
}

class SickLeaveRequestSheet extends StatefulWidget {
  const SickLeaveRequestSheet({super.key});

  @override
  State<SickLeaveRequestSheet> createState() => _SickLeaveRequestSheetState();
}

class _SickLeaveRequestSheetState extends State<SickLeaveRequestSheet> {
  int _durationIndex = 0;
  final _durations = const ['يوم', 'يومان', '3 أيام', 'أسبوع'];

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
          AppText('طلب إجازة مرضية',
              isHeading: true,
              fontSize: 17,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor.themeColor),
          4.height,
          AppText('تصدر بعد موافقة الطبيب',
              fontSize: 11.5, color: AppColors.mutedColor.themeColor),
          18.height,
          AppText('المدة المطلوبة',
              fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor),
          10.height,
          Wrap(
            spacing: 7.w,
            runSpacing: 8.h,
            children: [
              for (var i = 0; i < _durations.length; i++)
                GestureDetector(
                  onTap: () => setState(() => _durationIndex = i),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 9.h),
                    decoration: BoxDecoration(
                      color: _durationIndex == i
                          ? AppColors.primaryColor.themeColor
                          : AppColors.surfaceColor.themeColor,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      _durations[i],
                      style: TextStyle(
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w600,
                        color: _durationIndex == i
                            ? Colors.white
                            : AppColors.textSecondaryColor.themeColor,
                      ),
                    ),
                  ),
                ),
            ],
          ),
          20.height,
          CustomButton(
            title: 'أرسل الطلب',
            onTap: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('أُرسل طلب الإجازة — سيصدر بعد موافقة الطبيب')),
              );
            },
          ),
        ],
      ),
    );
  }
}
