import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import 'onboarding_slide_data.dart';

/// A self-drawn (no image assets) illustration for one onboarding page:
/// a soft color blob with a lead icon in the middle and two small "orbiting"
/// accent icons — themed per [OnboardingIllustrationType] using [AppColors]
/// so it stays consistent (and correct in dark mode) with the rest of the app.
class OnboardingIllustration extends StatelessWidget {
  const OnboardingIllustration({super.key, required this.illustration});

  final OnboardingIllustrationType illustration;

  _IllustrationStyle _styleFor(OnboardingIllustrationType type) {
    switch (type) {
      case OnboardingIllustrationType.welcome:
        return _IllustrationStyle(
          blobColor: AppColors.primaryColor.themeColor,
          leadIcon: Icons.favorite_rounded,
          accentIconA: Icons.calendar_month_rounded,
          accentIconB: Icons.medical_services_rounded,
        );
      case OnboardingIllustrationType.telemed:
        return _IllustrationStyle(
          blobColor: AppColors.secondaryColor.themeColor,
          leadIcon: Icons.video_call_rounded,
          accentIconA: Icons.chat_bubble_rounded,
          accentIconB: Icons.headset_mic_rounded,
        );
      case OnboardingIllustrationType.pharmacy:
        return _IllustrationStyle(
          blobColor: AppColors.accentGold.themeColor,
          leadIcon: Icons.medication_rounded,
          accentIconA: Icons.local_pharmacy_rounded,
          accentIconB: Icons.delivery_dining_rounded,
        );
      case OnboardingIllustrationType.family:
        return _IllustrationStyle(
          blobColor: AppColors.primaryLightColor.themeColor,
          leadIcon: Icons.folder_shared_rounded,
          accentIconA: Icons.groups_rounded,
          accentIconB: Icons.shield_rounded,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _styleFor(illustration);

    return Center(
      child: SizedBox(
        width: 220.w,
        height: 220.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // ── Soft background blob ──────────────────────────────────────
            Container(
              width: 220.w,
              height: 220.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    style.blobColor.withValues(alpha: 0.18),
                    style.blobColor.withValues(alpha: 0.06),
                  ],
                ),
              ),
            ),
            Container(
              width: 160.w,
              height: 160.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: style.blobColor.withValues(alpha: 0.12),
              ),
            ),

            // ── Lead icon medallion ─────────────────────────────────────────
            Container(
              width: 104.w,
              height: 104.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: style.blobColor,
                boxShadow: [
                  BoxShadow(
                    color: style.blobColor.withValues(alpha: 0.35),
                    blurRadius: 24,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Icon(style.leadIcon, color: Colors.white, size: 46.sp),
            ),

            // ── Orbiting accent A (top-end) ─────────────────────────────────
            Positioned(
              top: 6.w,
              right: 18.w,
              child: _AccentBadge(icon: style.accentIconA, color: style.blobColor),
            ),

            // ── Orbiting accent B (bottom-start) ────────────────────────────
            Positioned(
              bottom: 12.w,
              left: 10.w,
              child: _AccentBadge(icon: style.accentIconB, color: style.blobColor),
            ),
          ],
        ),
      ),
    );
  }
}

class _AccentBadge extends StatelessWidget {
  const _AccentBadge({required this.icon, required this.color});

  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48.w,
      height: 48.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.cardColor.themeColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(icon, color: color, size: 22.sp),
    );
  }
}

class _IllustrationStyle {
  const _IllustrationStyle({
    required this.blobColor,
    required this.leadIcon,
    required this.accentIconA,
    required this.accentIconB,
  });

  final Color blobColor;
  final IconData leadIcon;
  final IconData accentIconA;
  final IconData accentIconB;
}
