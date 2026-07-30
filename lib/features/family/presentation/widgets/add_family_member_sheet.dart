import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';

Future<void> showAddFamilyMemberSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => const AddFamilyMemberSheet(),
  );
}

class AddFamilyMemberSheet extends StatefulWidget {
  const AddFamilyMemberSheet({super.key});

  @override
  State<AddFamilyMemberSheet> createState() => _AddFamilyMemberSheetState();
}

class _AddFamilyMemberSheetState extends State<AddFamilyMemberSheet> {
  final _idController = TextEditingController();

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
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
            AppText('إضافة فرد للعائلة',
                isHeading: true,
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryColor.themeColor),
            4.height,
            AppText('ربط ملف طبي بحسابك بعد التحقق',
                fontSize: 11.5, color: AppColors.mutedColor.themeColor),
            18.height,
            AppText('رقم الهوية', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor),
            8.height,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor.themeColor,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: TextField(
                controller: _idController,
                textDirection: TextDirection.ltr,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: InputBorder.none, hintText: '1XXXXXXXXX'),
              ),
            ),
            14.height,
            Container(
              padding: EdgeInsets.all(13.r),
              decoration: BoxDecoration(
                color: AppColors.surfaceColor.themeColor,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: AppText(
                'ستصلك رسالة تحقق عبر النفاذ الوطني — بعدها يظهر السجل الطبي ضمن أفراد عائلتك.',
                fontSize: 11,
                color: AppColors.textSecondaryColor.themeColor,
                height: 1.7,
              ),
            ),
            18.height,
            CustomButton(
              title: 'تحقق وأضف',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('أُرسل طلب الربط — بانتظار موافقتهم')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
