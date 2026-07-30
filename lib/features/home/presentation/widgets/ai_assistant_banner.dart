import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/utils/app_svg_icons.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_svg_icon.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

/// Promotional card for the AI assistant feature, matching the home
/// screen's green gradient banner with decorative background circles.
class AiAssistantBanner extends StatelessWidget {
  const AiAssistantBanner({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final light = AppColors.primaryLightColor.themeColor;
    final dark = AppColors.primaryColor.themeColor;

    return CustomTapEffect(
      onTap: onTap ?? () {},
      isClickable: onTap != null,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [dark, light],
          ),
          boxShadow: [
            BoxShadow(
              color: dark.withValues(alpha: 0.25),
              blurRadius: 14,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned(
              top: -20,
              left: -30,
              child: _decorCircle(110, 0.06),
            ),
            Positioned(
              bottom: -40,
              right: 20,
              child: _decorCircle(80, 0.05),
            ),
            Padding(
              padding: EdgeInsets.all(15.r),
              child: Row(
                children: [
                  Container(
                    width: 48.r,
                    height: 48.r,

                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Center(
                      child: AppSvgIcon(AppSvgIcons.sparkle,
                          size: 24.sp, color: Colors.white),
                    ),
                  ),
                  13.width,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                LocaleKeys.home_aiAssistantTitle.tr(),
                                style: TextStyle(
                                  fontFamily: AppFonts.headingFont,
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            7.width,
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 7.w, vertical: 2.h),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.25),
                                borderRadius: BorderRadius.circular(99),
                              ),
                              child: Text(
                                LocaleKeys.home_aiAssistantBadge.tr(),
                                style: TextStyle(
                                  fontSize: 9.sp,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        3.height,
                        Text(
                          LocaleKeys.home_aiAssistantDesc.tr(),
                          style: TextStyle(
                            fontFamily: AppFonts.bodyFont,
                            fontSize: 11.sp,
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  AppSvgIcon(
                    AppSvgIcons.chevronRow,
                    size: 17.sp,
                    color: Colors.white.withValues(alpha: 0.7),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _decorCircle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}
