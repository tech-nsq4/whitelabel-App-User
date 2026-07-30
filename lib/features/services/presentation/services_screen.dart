import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_svg_icon.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/grid_action_tile.dart';
import '../../../core/widgets/screen_header.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            const ScreenHeader(
                title: 'الخدمات', subtitle: 'كل ما تحتاجه في مكان واحد'),
            AppCard(
              padding: EdgeInsets.all(18.r),
              color: AppColors.primaryColor.themeColor,
              borderColor: Colors.transparent,
              margin: EdgeInsets.only(bottom: 20.h),
              onTap: () => Navigator.pushNamed(context, Routes.book),
              child: Row(
                children: [
                  Container(
                    width: 46.r,
                    height: 46.r,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Center(
                      child:
                          AppSvgIcon(AppSvgIcons.calendar, size: 22.sp, color: Colors.white),
                    ),
                  ),
                  14.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppText('حجز موعد',
                            isHeading: true, fontSize: 15, color: Colors.white),
                        2.height,
                        AppText('في العيادة أو استشارة بالفيديو',
                            fontSize: 11, color: Colors.white.withValues(alpha: 0.72)),
                      ],
                    ),
                  ),
                  AppSvgIcon(AppSvgIcons.chevronRow,
                      size: 17.sp, color: Colors.white.withValues(alpha: 0.6)),
                ],
              ),
            ),
            _SectionTitle('رعاية'),
            10.height,
            Row(children: [
              Expanded(
                child: GridActionTile(
                  icon: AppSvgIcons.videoCam,
                  label: 'استشارة',
                  subLabel: 'عن بعد',
                  onTap: () => Navigator.pushNamed(context, Routes.telemed),
                ),
              ),
              10.width,
              Expanded(
                child: GridActionTile(
                  icon: AppSvgIcons.home2,
                  label: 'رعاية',
                  subLabel: 'منزلية',
                  onTap: () => Navigator.pushNamed(context, Routes.homeCare),
                ),
              ),
              10.width,
              Expanded(
                child: GridActionTile(
                  icon: AppSvgIcons.ambulanceAlt,
                  label: 'طوارئ',
                  subLabel: '24/7',
                  iconColor: AppColors.errorColor.themeColor,
                  onTap: () => Navigator.pushNamed(context, Routes.emergency),
                ),
              ),
            ]),
            20.height,
            _SectionTitle('فحوصات'),
            10.height,
            Row(children: [
              Expanded(
                child: GridActionTile(
                  icon: AppSvgIcons.flask,
                  label: 'المختبر',
                  subLabel: 'تحاليل',
                  onTap: () => Navigator.pushNamed(context, Routes.labClinics),
                ),
              ),
              10.width,
              Expanded(
                child: GridActionTile(
                  icon: AppSvgIcons.xray,
                  label: 'الأشعة',
                  subLabel: 'صور وتقارير',
                  onTap: () => Navigator.pushNamed(context, Routes.xrayClinics),
                ),
              ),
              10.width,
              const Expanded(child: SizedBox()),
            ]),
            20.height,
            _SectionTitle('إداري'),
            10.height,
            Row(children: [
              Expanded(
                child: GridActionTile(
                  icon: AppSvgIcons.wallet,
                  label: 'الفواتير',
                  subLabel: 'والمحفظة',
                  onTap: () => Navigator.pushNamed(context, Routes.payments),
                ),
              ),
              10.width,
              Expanded(
                child: GridActionTile(
                  icon: AppSvgIcons.document,
                  label: 'التقارير',
                  subLabel: 'والإجازات',
                  onTap: () => Navigator.pushNamed(context, Routes.reports),
                ),
              ),
              10.width,
              Expanded(
                child: GridActionTile(
                  icon: AppSvgIcons.mapPin,
                  label: 'تواصل',
                  subLabel: 'الفرع',
                  onTap: () => Navigator.pushNamed(context, Routes.contact),
                ),
              ),
            ]),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10.sp,
        fontWeight: FontWeight.w600,
        letterSpacing: 1.4,
        color: AppColors.mutedColor.themeColor,
      ),
    );
  }
}
