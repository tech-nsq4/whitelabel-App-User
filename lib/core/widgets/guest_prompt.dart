import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../app/router/routes.dart';
import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import '../utils/locale_keys.dart';
import 'app_button.dart';
import 'app_text.dart';

/// Full-page "sign in required" state for a member-only screen reached by a
/// guest session (e.g. `FamilyScreen`) — replaces the whole screen body,
/// not just an inline card.
class GuestPrompt extends StatelessWidget {
  const GuestPrompt({super.key, required this.title, required this.description});

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72.w,
              height: 72.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryColor.themeColor.withValues(alpha: 0.12),
              ),
              child: Icon(Icons.person_outline_rounded, color: AppColors.primaryColor.themeColor, size: 34.sp),
            ),
            18.height,
            AppText(title,
                isHeading: true,
                fontSize: 17,
                textAlign: TextAlign.center,
                color: AppColors.textPrimaryColor.themeColor,
                fontWeight: FontWeight.w700),
            8.height,
            AppText(description,
                fontSize: 12.5,
                textAlign: TextAlign.center,
                color: AppColors.mutedColor.themeColor,
                height: 1.6),
            22.height,
            CustomButton(
              title: LocaleKeys.profile_loginNow.tr(),
              onTap: () => Navigator.pushNamedAndRemoveUntil(context, Routes.loginScreen, (_) => false),
            ),
          ],
        ),
      ),
    );
  }
}
