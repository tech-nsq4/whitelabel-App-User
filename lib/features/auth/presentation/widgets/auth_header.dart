import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';
import '../../../../core/widgets/primary_header.dart';

/// Shared brand header (badge + wordmark over the primary-colour banner)
/// used by both the Login and Register screens.
class AuthHeader extends StatelessWidget {
  const AuthHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryHeader(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const _BrandBadge(),
            16.height,
            AppText(
              LocaleKeys.app_name.tr(),
              isHeading: true,
              color: Colors.white,
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
            ),
            6.height,
            AppText(
              LocaleKeys.auth_tagline.tr(),
              color: Colors.white.withValues(alpha: 0.82),
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
            ),
          ],
        ),
      ),
    );
  }
}

/// The white, softly-glowing medallion carrying the brand mark — a
/// self-drawn stand-in for a logo image, matching the vector illustrations
/// used across onboarding.
class _BrandBadge extends StatelessWidget {
  const _BrandBadge();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 108.w,
      height: 108.w,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // ── Soft outer glow ──────────────────────────────────────────
          Container(
            width: 108.w,
            height: 108.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.10),
            ),
          ),
          Container(
            width: 84.w,
            height: 84.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white.withValues(alpha: 0.16),
            ),
          ),

          // ── Solid badge ───────────────────────────────────────────────
          Container(
            width: 64.w,
            height: 64.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(
                color: AppColors.accentGold.themeColor,
                width: 2,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.15),
                  blurRadius: 16,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              Icons.health_and_safety_rounded,
              color: AppColors.primaryColor.themeColor,
              size: 30.sp,
            ),
          ),
        ],
      ),
    );
  }
}
