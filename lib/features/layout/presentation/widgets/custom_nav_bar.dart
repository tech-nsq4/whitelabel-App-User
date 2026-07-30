import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/widgets/app_svg_icon.dart';

class NavBarItem {
  const NavBarItem({required this.icon, required this.labelKey});

  final String icon;
  final String labelKey;
}

/// Floating bottom navigation bar with a raised center action button,
/// matching the reference design's `.nav` / `.nav-in` / `.fab`.
class CustomNavBar extends StatelessWidget {
  const CustomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    required this.items,
    required this.onFabTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<NavBarItem> items;
  final VoidCallback onFabTap;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final muted = AppColors.mutedColor.themeColor;
    final paper = AppColors.backgroundColor.themeColor;

    // First half of destinations sit before the FAB, second half after —
    // mirrors the design's home / medfile / [FAB] / family / account layout.
    final mid = (items.length / 2).ceil();
    final leading = items.sublist(0, mid);
    final trailing = items.sublist(mid);

    return SizedBox(
      height: 88.h,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          Positioned.fill(
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [paper, paper.withValues(alpha: 0)],
                    stops: const [0.62, 1],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 0),
            child: Container(
              height: 58.h,
              decoration: BoxDecoration(
                color: AppColors.cardColor.themeColor,
                border: Border.all(color: AppColors.dividerColor.themeColor),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.textPrimaryColor.themeColor
                        .withValues(alpha: 0.10),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  for (var i = 0; i < leading.length; i++)
                    _NavButton(
                      data: leading[i],
                      isActive: currentIndex == i,
                      activeColor: primary,
                      inactiveColor: muted,
                      onTap: () => onTap(i),
                    ),
                  SizedBox(width: 50.w),
                  for (var i = 0; i < trailing.length; i++)
                    _NavButton(
                      data: trailing[i],
                      isActive: currentIndex == mid + i,
                      activeColor: primary,
                      inactiveColor: muted,
                      onTap: () => onTap(mid + i),
                    ),
                ],
              ),
            ),
          ),
          _Fab(onTap: onFabTap),
        ],
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.data,
    required this.isActive,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  final NavBarItem data;
  final bool isActive;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final color = isActive ? activeColor : inactiveColor;
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AppSvgIcon(data.icon, size: 22.sp, color: color),
            3.height,
            Text(
              data.labelKey.tr(),
              style: TextStyle(
                fontFamily: AppFonts.bodyFont,
                fontSize: 9.5.sp,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
            3.height,
            AnimatedOpacity(
              duration: AppConstants.shortAnimationDuration,
              opacity: isActive ? 1 : 0,
              child: Container(
                width: 4.r,
                height: 4.r,
                decoration: BoxDecoration(
                  color: activeColor,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Fab extends StatelessWidget {
  const _Fab({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final light = AppColors.primaryLightColor.themeColor;
    final dark = AppColors.primaryDarkColor.themeColor;

    return Positioned(
      bottom: 38.h,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 50.w,
          height: 50.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(17.r),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [light, dark],
            ),
            boxShadow: [
              BoxShadow(
                color: dark.withValues(alpha: 0.45),
                blurRadius: 22,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
