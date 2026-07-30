import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/list_row_tile.dart';
import '../../home/presentation/widgets/ai_assistant_banner.dart';

class MedicalFileScreen extends StatelessWidget {
  const MedicalFileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('سجلي الطبي',
                          style: TextStyle(
                              fontSize: 10.sp,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                              color: AppColors.mutedColor.themeColor)),
                      3.height,
                      AppText('أسرة العتيبي',
                          isHeading: true,
                          fontSize: 19,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryColor.themeColor),
                    ],
                  ),
                ),
                Container(
                  width: 40.r,
                  height: 40.r,
                  decoration: BoxDecoration(
                    color: AppColors.cardColor.themeColor,
                    borderRadius: BorderRadius.circular(18.r),
                    border: Border.all(color: AppColors.dividerColor.themeColor),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('تمت مشاركة السجل مع الطبيب — صالح 24 ساعة')),
                    ),
                    icon: Icon(Icons.ios_share_rounded,
                        size: 17.sp, color: AppColors.textPrimaryColor.themeColor),
                  ),
                ),
              ],
            ),
            18.height,
            AiAssistantBanner(
              onTap: () => Navigator.pushNamed(context, Routes.aiAssistant),
            ),
            18.height,
            _SectionTitle('السجل'),
            10.height,
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              margin: EdgeInsets.only(bottom: 18.h),
              child: Column(
                children: [
                  ListRowTile(
                    icon: AppSvgIcons.medicalFile,
                    title: 'زياراتي',
                    subtitle: '14 زيارة · آخرها 8 يونيو',
                    onTap: () => Navigator.pushNamed(context, Routes.visits),
                  ),
                  ListRowTile(
                    icon: AppSvgIcons.flask,
                    title: 'نتائج المختبر',
                    subtitle: 'فيتامين د - منخفض',
                    iconBg: AppColors.warningColor.themeColor.withValues(alpha: 0.12),
                    iconColor: AppColors.warningColor.themeColor,
                    trailing: AppChip(
                      label: 'جديد',
                      background: AppColors.warningColor.themeColor.withValues(alpha: 0.12),
                      color: AppColors.warningColor.themeColor,
                    ),
                    onTap: () => Navigator.pushNamed(context, Routes.labClinics),
                  ),
                  ListRowTile(
                    icon: AppSvgIcons.xray,
                    title: 'الأشعة',
                    subtitle: 'ركبة اليمنى · 5 يونيو',
                    onTap: () => Navigator.pushNamed(context, Routes.xrayClinics),
                  ),
                  ListRowTile(
                    icon: AppSvgIcons.document,
                    title: 'الوصفات',
                    subtitle: 'وصفة سارية · رمز للصيدلية',
                    onTap: () => Navigator.pushNamed(context, Routes.phClinics),
                  ),
                  ListRowTile(
                    icon: AppSvgIcons.pill,
                    title: 'الأدوية',
                    subtitle: '3 أدوية نشطة',
                    onTap: () => Navigator.pushNamed(context, Routes.medications),
                  ),
                  ListRowTile(
                    icon: AppSvgIcons.heartbeat,
                    title: 'المؤشرات الحيوية',
                    subtitle: 'محدثة اليوم',
                    showDivider: false,
                    onTap: () => Navigator.pushNamed(context, Routes.vitals),
                  ),
                ],
              ),
            ),
            _SectionTitle('المدفوعات'),
            10.height,
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              margin: EdgeInsets.only(bottom: 18.h),
              child: Column(
                children: [
                  ListRowTile(
                    icon: AppSvgIcons.wallet,
                    title: 'فواتيري',
                    subtitle: 'فاتورة واحدة غير مدفوعة',
                    iconBg: AppColors.warningColor.themeColor.withValues(alpha: 0.12),
                    iconColor: AppColors.warningColor.themeColor,
                    trailing: AppChip(
                      label: '180 ريال',
                      background: AppColors.warningColor.themeColor.withValues(alpha: 0.12),
                      color: AppColors.warningColor.themeColor,
                    ),
                    onTap: () => Navigator.pushNamed(context, Routes.payments),
                  ),
                  ListRowTile(
                    icon: AppSvgIcons.card,
                    title: 'محفظتي',
                    subtitle: '240 ريال + نقاط ولاء',
                    showDivider: false,
                    onTap: () => Navigator.pushNamed(context, Routes.payments),
                  ),
                ],
              ),
            ),
            _SectionTitle('صحتي'),
            10.height,
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Column(
                children: [
                  ListRowTile(
                    icon: AppSvgIcons.vaccine,
                    title: 'الحساسية والتطعيمات',
                    subtitle: 'حساسية البنسلين · تطعيم مستحق',
                    onTap: () => Navigator.pushNamed(context, Routes.immunity),
                  ),
                  ListRowTile(
                    icon: AppSvgIcons.document,
                    title: 'التقارير والإجازات',
                    subtitle: 'إجازة موثقة · إصدار تقرير',
                    onTap: () => Navigator.pushNamed(context, Routes.reports),
                  ),
                  ListRowTile(
                    icon: AppSvgIcons.chatBubble,
                    title: 'اسأل طبيبك',
                    subtitle: 'استفسار مجاني · رد خلال 24 ساعة',
                    showDivider: false,
                    onTap: () => Navigator.pushNamed(context, Routes.askDoctor),
                  ),
                ],
              ),
            ),
            50.height,
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
