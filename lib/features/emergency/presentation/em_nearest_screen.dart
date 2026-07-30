import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_header.dart';

class EmNearestScreen extends StatelessWidget {
  const EmNearestScreen({super.key});

  static const _ers = [
    ('طوارئ العلا', '2.3 كم · 6 دقائق', '12 د'),
    ('طوارئ المرجس', '5.8 كم · 12 دقيقة', '25 د'),
    ('طوارئ الماسين', '9.1 كم · 18 دقيقة', '8 د'),
  ];

  @override
  Widget build(BuildContext context) {
    final clay = AppColors.errorColor.themeColor;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(title: 'أقرب طوارئ', subtitle: 'مرتبة حسب المسافة والانتظار'),
            for (final er in _ers)
              AppCard(
                margin: EdgeInsets.only(bottom: 10.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 42.r,
                          height: 42.r,
                          decoration: BoxDecoration(
                            color: clay.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(13.r),
                          ),
                          child: Icon(Icons.location_on_rounded, color: clay, size: 20.sp),
                        ),
                        12.width,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AppText(er.$1,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimaryColor.themeColor),
                              2.height,
                              AppText(er.$2, fontSize: 10.5, color: AppColors.mutedColor.themeColor),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text(er.$3,
                                style: TextStyle(
                                    fontFamily: AppFonts.headingFont,
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.primaryColor.themeColor)),
                            AppText('انتظار', fontSize: 9, color: AppColors.mutedColor.themeColor),
                          ],
                        ),
                      ],
                    ),
                    10.height,
                    Row(children: [
                      Expanded(
                        child: CustomButton(
                            title: 'الاتجاهات', isOutlined: true, height: 36, fontSize: 11.5, onTap: () {}),
                      ),
                      8.width,
                      Expanded(
                        child: CustomButton(
                          title: 'سجّل حضورك',
                          height: 36,
                          fontSize: 11.5,
                          onTap: () => Navigator.pushNamed(context, Routes.emCheckin),
                        ),
                      ),
                    ]),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
