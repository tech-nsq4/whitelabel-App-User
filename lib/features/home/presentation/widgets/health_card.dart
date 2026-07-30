import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/custom_tap_effect.dart';
import 'health_card_painters.dart';

/// The patient health card — a physical-card-styled hero element with an
/// engraved geometric pattern, a gold accent line, and a mock QR code.
class HealthCard extends StatelessWidget {
  const HealthCard({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final dark = AppColors.primaryDarkColor.themeColor;
    final light = AppColors.primaryLightColor.themeColor;
    final gold = AppColors.accentGold.themeColor;

    return CustomTapEffect(
      onTap: onTap ?? () {},
      isClickable: onTap != null,
      child: Container(
        // padding: EdgeInsets.fromLTRB(20.w, 19.h, 20.w, 17.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [light, dark],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.textPrimaryColor.themeColor
                  .withValues(alpha: 0.28),
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
              padding: EdgeInsets.fromLTRB(20.w, 19.h, 20.w, 17.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.home_healthCardLabel.tr(),
                              style: TextStyle(
                                fontFamily: AppFonts.bodyFont,
                                fontSize: 9.5.sp,
                                letterSpacing: 1.6,
                                fontWeight: FontWeight.w600,
                                color: Colors.white.withValues(alpha: 0.55),
                              ),
                            ),
                            4.height,
                            Text(
                              LocaleKeys.home_orgName.tr(),
                              style: TextStyle(
                                fontFamily: AppFonts.headingFont,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Icon(Icons.star_rounded,
                          size: 26.sp,
                          color: Colors.white.withValues(alpha: 0.75)),
                    ],
                  ),
                  26.height,
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              LocaleKeys.home_familyName.tr(),
                              style: TextStyle(
                                fontFamily: AppFonts.headingFont,
                                fontSize: 17.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                            5.height,
                            Text(
                              '3 0 4 1 2',
                              style: TextStyle(
                                fontFamily: AppFonts.headingFont,
                                fontSize: 12.5.sp,
                                letterSpacing: 2.6,
                                color: Colors.white.withValues(alpha: 0.62),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: 52.r,
                        height: 52.r,
                        padding: EdgeInsets.all(5.r),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(11.r),
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
                    ],
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
