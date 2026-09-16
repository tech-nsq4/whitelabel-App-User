import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/network/api_endpoints.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/app_svg_icons.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/confirm_dialog.dart';
import '../../../core/widgets/list_row_tile.dart';
import '../../../core/widgets/screen_header.dart';
import '../../../core/widgets/section_header.dart';
import 'widgets/language_sheet.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = context.locale.languageCode == 'ar';
    final error = AppColors.errorColor.themeColor;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
          children: [
            ScreenHeader(title: LocaleKeys.settings_title.tr()),
            SectionHeader(title: LocaleKeys.settings_sectionGeneral.tr()),
            10.height,
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              margin: EdgeInsets.only(bottom: 20.h),
              child: ListRowTile(
                icon: AppSvgIcons.globe,
                title: LocaleKeys.settings_language.tr(),
                subtitle: isArabic
                    ? LocaleKeys.settings_arabic.tr()
                    : LocaleKeys.settings_english.tr(),
                showDivider: false,
                onTap: () => showLanguageSheet(context),
              ),
            ),
            SectionHeader(title: LocaleKeys.settings_sectionAbout.tr()),
            10.height,
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              margin: EdgeInsets.only(bottom: 20.h),
              child: Column(
                children: [
                  ListRowTile(
                    icon: AppSvgIcons.document,
                    title: LocaleKeys.settings_terms.tr(),
                    subtitle: LocaleKeys.settings_termsSubtitle.tr(),
                    onTap: () => _openPage(
                      context,
                      slug: ApiEndpoints.pageTermsSlug,
                      title: LocaleKeys.settings_terms.tr(),
                      icon: AppSvgIcons.document,
                    ),
                  ),
                  ListRowTile(
                    icon: AppSvgIcons.shieldLock,
                    title: LocaleKeys.settings_privacy.tr(),
                    subtitle: LocaleKeys.settings_privacySubtitle.tr(),
                    showDivider: false,
                    onTap: () => _openPage(
                      context,
                      slug: ApiEndpoints.pagePrivacySlug,
                      title: LocaleKeys.settings_privacy.tr(),
                      icon: AppSvgIcons.shieldLock,
                    ),
                  ),
                ],
              ),
            ),
            SectionHeader(title: LocaleKeys.settings_sectionAccount.tr()),
            10.height,
            AppCard(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              // borderColor: error.withValues(alpha: 0.35),
              child: ListRowTile(
                iconData: Icons.delete_forever_rounded,
                iconBg: error.withValues(alpha: 0.12),
                iconColor: error,
                titleColor: error,
                title: LocaleKeys.settings_deleteAccount.tr(),
                subtitle: LocaleKeys.settings_deleteAccountSubtitle.tr(),
                showChevron: false,
                showDivider: false,
                onTap: () => _confirmDeleteAccount(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openPage(
    BuildContext context, {
    required String slug,
    required String title,
    required String icon,
  }) {
    Navigator.pushNamed(context, Routes.contentPage, arguments: {
      'slug': slug,
      'title': title,
      'icon': icon,
    });
  }

  Future<void> _confirmDeleteAccount(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      icon: Icons.delete_forever_rounded,
      title: LocaleKeys.settings_deleteAccount.tr(),
      message: LocaleKeys.settings_deleteAccountMessage.tr(),
      confirmLabel: LocaleKeys.settings_deleteAccount.tr(),
      cancelLabel: LocaleKeys.common_cancel.tr(),
      iconColor: AppColors.errorColor.themeColor,
      confirmColor: AppColors.errorColor.themeColor,
    );
    if (!confirmed) return;
    AppOverlay.showSuccess(LocaleKeys.settings_deleteAccountSent.tr());
  }
}
