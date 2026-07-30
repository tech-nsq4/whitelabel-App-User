import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/list_row_tile.dart';
import '../../auth/logic/auth_cubit.dart';
import '../../home/presentation/widgets/health_card_modal.dart';
import '../../profile/logic/profile_cubit.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final isGuest = kIsGuest;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 110.h),
          children: [
            Row(
              children: [
                Container(
                  width: 58.r,
                  height: 58.r,
                  decoration: BoxDecoration(color: primary, borderRadius: BorderRadius.circular(19.r)),
                  alignment: Alignment.center,
                  child: Text(isGuest ? '؟' : 'أ',
                      style: TextStyle(
                          fontFamily: AppFonts.headingFont,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white)),
                ),
                14.width,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AppText(isGuest ? 'زائر' : 'أسرة العتيبي',
                          isHeading: true,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimaryColor.themeColor),
                      2.height,
                      AppText(isGuest ? 'سجّل الدخول لحفظ بياناتك' : 'رقم الملف 30412',
                          fontSize: 11, color: AppColors.mutedColor.themeColor),
                    ],
                  ),
                ),
                if (!isGuest)
                  Container(
                    width: 36.r,
                    height: 36.r,
                    decoration: BoxDecoration(
                      color: AppColors.cardColor.themeColor,
                      borderRadius: BorderRadius.circular(13.r),
                      border: Border.all(color: AppColors.dividerColor.themeColor),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () => Navigator.pushNamed(context, Routes.profile),
                      icon: Icon(Icons.edit_outlined, size: 16.sp, color: AppColors.mutedColor.themeColor),
                    ),
                  ),
              ],
            ),
            22.height,
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              margin: EdgeInsets.only(bottom: 16.h),
              child: Column(
                children: [
                  ListRowTile(
                    icon: AppSvgIcons.card,
                    title: 'البطاقة الصحية',
                    subtitle: 'عرض رمز الدخول السريع',
                    onTap: () => showHealthCardModal(context),
                  ),
                  ListRowTile(
                    icon: AppSvgIcons.family,
                    title: 'الحسابات المرتبطة',
                    subtitle: '3 أفراد',
                    onTap: () => Navigator.pushNamed(context, Routes.family),
                  ),
                  ListRowTile(
                    icon: AppSvgIcons.mapPin,
                    title: 'الفرع المفضل',
                    subtitle: 'العلا الرئيسي · 2.3 كم',
                    showDivider: false,
                    onTap: () => Navigator.pushNamed(context, Routes.branches),
                  ),
                ],
              ),
            ),
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              margin: EdgeInsets.only(bottom: 16.h),
              child: Column(
                children: [
                  ListRowTile(
                    icon: AppSvgIcons.bell,
                    title: 'التنبيهات',
                    subtitle: 'تذكير المواعيد والنتائج',
                    onTap: () => Navigator.pushNamed(context, Routes.notifications),
                  ),
                  ListRowTile(
                    icon: AppSvgIcons.shieldLock,
                    title: 'الخصوصية والصلاحيات',
                    subtitle: 'من يرى سجلك',
                    onTap: () => Navigator.pushNamed(context, Routes.privacy),
                  ),
                  ListRowTile(
                    icon: AppSvgIcons.settingsGear,
                    title: 'الإعدادات',
                    subtitle: 'اللغة والمظهر',
                    showDivider: false,
                    onTap: () => Navigator.pushNamed(context, Routes.settings),
                  ),
                ],
              ),
            ),
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              margin: EdgeInsets.only(bottom: 16.h),
              child: Column(
                children: [
                  ListRowTile(
                    icon: AppSvgIcons.stethoscope,
                    title: 'رأيك يهمنا',
                    subtitle: 'قيّم تجربتك',
                    onTap: () => Navigator.pushNamed(context, Routes.feedback),
                  ),
                  ListRowTile(
                    icon: AppSvgIcons.chatBubble,
                    title: 'تواصل معنا',
                    subtitle: 'اتصال أو واتساب',
                    showDivider: false,
                    onTap: () => Navigator.pushNamed(context, Routes.contact),
                  ),
                ],
              ),
            ),
            if (!isGuest)
              AppCard(
                onTap: () => _logout(context),
                child: Row(
                  children: [
                    Icon(Icons.logout_rounded, color: AppColors.errorColor.themeColor, size: 18.sp),
                    10.width,
                    AppText('تسجيل الخروج',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.errorColor.themeColor),
                  ],
                ),
              )
            else
              AppCard(
                color: AppColors.primaryColor.themeColor,
                borderColor: Colors.transparent,
                onTap: () => Navigator.pushNamedAndRemoveUntil(
                    context, Routes.loginScreen, (_) => false),
                child: Center(
                  child: AppText('سجّل الدخول', isHeading: true, color: Colors.white, fontSize: 13),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _logout(BuildContext context) {
    context.read<ProfileCubit>().reset();
    context.read<AuthCubit>().logout();
    Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (_) => false);
  }
}
