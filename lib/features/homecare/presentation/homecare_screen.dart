import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_header.dart';

class HomeCareScreen extends StatefulWidget {
  const HomeCareScreen({super.key});

  @override
  State<HomeCareScreen> createState() => _HomeCareScreenState();
}

class _HomeCareScreenState extends State<HomeCareScreen> {
  int _serviceIndex = 0;
  int _timeIndex = 0;

  static const _services = [
    ('زيارة طبيب', 250),
    ('تمريض منزلي', 150),
    ('سحب عينات', 80),
    ('علاج طبيعي', 200),
  ];
  static const _times = ['اليوم مساءً', 'غدًا صباحًا', 'غدًا مساءً'];

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(title: 'الرعاية المنزلية', subtitle: 'الفريق الطبي يصل إلى بيتك'),
            Text('الخدمة',
                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor)),
            10.height,
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10.w,
              mainAxisSpacing: 10.h,
              childAspectRatio: 1.5,
              children: [
                for (var i = 0; i < _services.length; i++)
                  GestureDetector(
                    onTap: () => setState(() => _serviceIndex = i),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 10.w),
                      decoration: BoxDecoration(
                        color: _serviceIndex == i ? primary : AppColors.cardColor.themeColor,
                        borderRadius: BorderRadius.circular(16.r),
                        border: _serviceIndex == i
                            ? null
                            : Border.all(color: AppColors.dividerColor.themeColor),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(_services[i].$1,
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: _serviceIndex == i
                                  ? Colors.white
                                  : AppColors.textPrimaryColor.themeColor),
                          6.height,
                          Text('${_services[i].$2} ريال',
                              style: TextStyle(
                                  fontFamily: AppFonts.headingFont,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: _serviceIndex == i ? Colors.white : primary)),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
            18.height,
            Text('الوقت',
                style: TextStyle(fontSize: 10.sp, fontWeight: FontWeight.w600, color: AppColors.mutedColor.themeColor)),
            10.height,
            Row(
              children: [
                for (var i = 0; i < _times.length; i++)
                  Expanded(
                    child: GestureDetector(
                      onTap: () => setState(() => _timeIndex = i),
                      child: Container(
                        margin: EdgeInsets.only(left: i == _times.length - 1 ? 0 : 8.w),
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        decoration: BoxDecoration(
                          color: _timeIndex == i ? primary : AppColors.surfaceColor.themeColor,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(_times[i],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 11.sp,
                                fontWeight: FontWeight.w600,
                                color: _timeIndex == i ? Colors.white : AppColors.textSecondaryColor.themeColor)),
                      ),
                    ),
                  ),
              ],
            ),
            20.height,
            CustomButton(
              title: 'اطلب الزيارة',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('تم طلب ${_services[_serviceIndex].$1} — ${_times[_timeIndex]}')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
