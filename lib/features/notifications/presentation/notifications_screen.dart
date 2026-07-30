import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/screen_header.dart';
import '../data/notification_model.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late List<NotificationModel> _items = [
    NotificationModel(
      icon: AppSvgIcons.calendar,
      title: 'موعدك غدًا 10:30 ص',
      body: 'د. خالد العتيبي — فرع العلا. سجّل حضورك قبل الموعد بساعة من البطاقة الصحية.',
      time: 'اليوم 4:15 م',
      accentColor: AppColors.primaryColor.themeColor,
    ),
    NotificationModel(
      icon: AppSvgIcons.videoCam,
      title: 'جلستك جاهزة',
      body: 'د. ريم الدوسري في انتظارك. ادخل الجلسة من شاشة الاستشارات.',
      time: 'اليوم 2:00 م',
      accentColor: AppColors.primaryColor.themeColor,
    ),
    NotificationModel(
      icon: AppSvgIcons.flask,
      title: 'نتيجة فيتامين د صدرت',
      body: 'القراءة 22 ng/mL — أقل من الطبيعي. راجع التوصية في سجلك.',
      time: 'اليوم 11:20 ص',
      accentColor: AppColors.warningColor.themeColor,
    ),
    NotificationModel(
      icon: AppSvgIcons.family,
      title: 'تم ربط ولي عبدالله',
      body: 'وافق على الربط عبر رمز التحقق. سجله الطبي متاح الآن في حسابك.',
      time: 'أمس 8:40 م',
      isRead: true,
    ),
  ];

  void _readAll() => setState(() {
        _items = _items.map((n) => n.copyWith(isRead: true)).toList();
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            ScreenHeader(
              title: 'التنبيهات',
              trailing: GestureDetector(
                onTap: _readAll,
                child: AppText('تعليم الكل كمقروء',
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryColor.themeColor),
              ),
            ),
            for (final n in _items)
              AppCard(
                margin: EdgeInsets.only(bottom: 10.h),
                color: n.isRead
                    ? AppColors.cardColor.themeColor.withValues(alpha: 0.6)
                    : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 40.r,
                      height: 40.r,
                      decoration: BoxDecoration(
                        color: (n.accentColor ?? AppColors.mutedColor.themeColor)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(13.r),
                      ),
                      child: Center(
                        child: AppSvgIcon(n.icon,
                            size: 18.sp,
                            color: n.accentColor ?? AppColors.mutedColor.themeColor),
                      ),
                    ),
                    12.width,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppText(n.title,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimaryColor.themeColor),
                          4.height,
                          AppText(n.body,
                              fontSize: 11,
                              color: AppColors.mutedColor.themeColor,
                              height: 1.5),
                          6.height,
                          AppText(n.time,
                              fontSize: 10, color: AppColors.hintColor.themeColor),
                        ],
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
