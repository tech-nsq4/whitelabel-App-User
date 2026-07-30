import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import 'health_card_painters.dart';

/// Full detail view of the patient health card, shown inside
/// [showHealthCardModal] — a centered layout with a large QR code and vitals
/// row, distinct from the compact [HealthCard] used on the home screen.
class HealthCardDetail extends StatelessWidget {
  const HealthCardDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.primaryDarkColor.themeColor;
    final light = AppColors.primaryLightColor.themeColor;
    final gold = AppColors.accentGold.themeColor;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.r),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: [light, dark],
        ),
        boxShadow: [
          BoxShadow(
            color:
                AppColors.textPrimaryColor.themeColor.withValues(alpha: 0.28),
            blurRadius: 40,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(painter: NajdiPatternPainter()),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 2,
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  gold.withValues(alpha: 0),
                  gold,
                  Colors.white,
                  gold,
                  gold.withValues(alpha: 0),
                ], stops: const [
                  0,
                  0.3,
                  0.5,
                  0.7,
                  1,
                ]),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(24.w, 22.h, 24.w, 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  LocaleKeys.home_healthCardLabel.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.bodyFont,
                    fontSize: 9.5.sp,
                    letterSpacing: 1.6,
                    fontWeight: FontWeight.w600,
                    color: Colors.white.withValues(alpha: 0.55),
                  ),
                ),
                6.height,
                Text(
                  LocaleKeys.home_orgName.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.headingFont,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                22.height,
                Container(
                  width: 150.r,
                  height: 150.r,
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.28),
                        blurRadius: 14,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: CustomPaint(painter: QrMockPainter()),
                ),
                20.height,
                Text(
                  LocaleKeys.home_patientName.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.headingFont,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                4.height,
                Text(
                  LocaleKeys.home_patientId.tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: AppFonts.headingFont,
                    fontSize: 13.sp,
                    letterSpacing: 3,
                    color: Colors.white.withValues(alpha: 0.62),
                  ),
                ),
                20.height,
                Row(
                  children: [
                    Expanded(
                      child: _StatTile(
                        value: '64',
                        label: LocaleKeys.home_weightUnit.tr(),
                      ),
                    ),
                    8.width,
                    Expanded(
                      child: _StatTile(
                        value: '162',
                        label: LocaleKeys.home_heightUnit.tr(),
                      ),
                    ),
                    8.width,
                    Expanded(
                      child: _StatTile(
                        value: '32',
                        label: LocaleKeys.home_ageUnit.tr(),
                      ),
                    ),
                    8.width,
                    Expanded(
                      child: _StatTile(
                        value: '+0',
                        label: LocaleKeys.home_bloodTypeLabel.tr(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A single stat pill (value + unit label) shown in the health card detail
/// footer — intentionally private: a tiny, layout-only piece of
/// [HealthCardDetail] with no use outside it.
class _StatTile extends StatelessWidget {
  const _StatTile({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 4.w),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontFamily: AppFonts.headingFont,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          3.height,
          Text(
            label,
            style: TextStyle(
              fontFamily: AppFonts.bodyFont,
              fontSize: 9.5.sp,
              color: Colors.white.withValues(alpha: 0.62),
            ),
          ),
        ],
      ),
    );
  }
}
