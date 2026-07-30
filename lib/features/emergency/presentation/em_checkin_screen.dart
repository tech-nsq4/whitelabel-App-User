import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/screen_header.dart';

class EmCheckinScreen extends StatefulWidget {
  const EmCheckinScreen({super.key});

  @override
  State<EmCheckinScreen> createState() => _EmCheckinScreenState();
}

class _EmCheckinScreenState extends State<EmCheckinScreen> {
  int _patientIndex = 0;
  int _etaIndex = 0;

  @override
  Widget build(BuildContext context) {
    final clay = AppColors.errorColor.themeColor;
    final patients = const ['نورة (أنا)', 'عبدالله', 'سعود'];
    final etas = const ['خلال 15 د', 'خلال 30 د', 'خلال ساعة'];

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(title: 'تسجيل حضور مسبق', subtitle: 'سجّل وأنت في الطريق'),
            Text('المريض',
                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor)),
            10.height,
            _chipsRow(patients, _patientIndex, (i) => setState(() => _patientIndex = i)),
            18.height,
            Text('وقت الوصول',
                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor)),
            10.height,
            _chipsRow(etas, _etaIndex, (i) => setState(() => _etaIndex = i)),
            20.height,
            CustomButton(
              title: 'سجّل حضورك',
              color: clay,
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('سُجّل حضورك — كود ER-48')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _chipsRow(List<String> items, int selected, ValueChanged<int> onTap) {
    return Row(
      children: [
        for (var i = 0; i < items.length; i++)
          Expanded(
            child: GestureDetector(
              onTap: () => onTap(i),
              child: Container(
                margin: EdgeInsets.only(left: i == items.length - 1 ? 0 : 8.w),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                decoration: BoxDecoration(
                  color: selected == i
                      ? AppColors.primaryColor.themeColor
                      : AppColors.surfaceColor.themeColor,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Text(items[i],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 11.5.sp,
                        fontWeight: FontWeight.w600,
                        color: selected == i
                            ? Colors.white
                            : AppColors.textSecondaryColor.themeColor)),
              ),
            ),
          ),
      ],
    );
  }
}
