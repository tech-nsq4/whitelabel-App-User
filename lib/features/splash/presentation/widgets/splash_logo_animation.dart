import 'dart:math' as math;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_images.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_text.dart';

class SplashLogoAnimation extends StatefulWidget {
  const SplashLogoAnimation({super.key});

  @override
  State<SplashLogoAnimation> createState() => _SplashLogoAnimationState();
}

class _SplashLogoAnimationState extends State<SplashLogoAnimation>
    with TickerProviderStateMixin {
  late final AnimationController _intro;
  late final AnimationController _breath;

  late final Animation<double> _logoTravel;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _glow;
  late final Animation<double> _taglineOpacity;
  late final Animation<double> _taglineShift;

  @override
  void initState() {
    super.initState();

    _intro = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    );
    _breath = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _logoTravel = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.06, 0.68, curve: Curves.easeOutCubic),
    );
    _logoScale = Tween<double>(begin: 0.10, end: 1).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.06, 0.74, curve: Curves.easeOutBack),
      ),
    );
    _logoOpacity = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.06, 0.34, curve: Curves.easeOut),
    );

    _glow = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.34, 0.95, curve: Curves.easeOutCubic),
    );

    _taglineOpacity = CurvedAnimation(
      parent: _intro,
      curve: const Interval(0.74, 1, curve: Curves.easeOut),
    );
    _taglineShift = Tween<double>(begin: 16, end: 0).animate(
      CurvedAnimation(
        parent: _intro,
        curve: const Interval(0.74, 1, curve: Curves.easeOutCubic),
      ),
    );

    _intro.forward().whenComplete(() {
      if (mounted) _breath.repeat(reverse: true);
    });
  }

  @override
  void dispose() {
    _intro.dispose();
    _breath.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final gold = AppColors.accentGold.themeColor;

    return AnimatedBuilder(
      animation: Listenable.merge([_intro, _breath]),
      builder: (context, _) {
        final travel = _logoTravel.value;
        final incoming = 1 - travel;
        final wobble = math.sin(travel * math.pi * 4) * 0.16 * incoming;
        final bob = math.sin(travel * math.pi * 5) * 20.h * incoming;
        final approach = incoming * 80.h;
        final breathScale = 1 + (_breath.value * 0.035);
        final glow = _glow.value;

        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.translate(
              offset: Offset(0, bob + approach),
              child: Transform.rotate(
                angle: wobble,
                child: Opacity(
                  opacity: _logoOpacity.value.clamp(0.0, 1.0),
                  child: Transform.scale(
                    scale: _logoScale.value.clamp(0.0, 2.0) * breathScale,
                    child: SizedBox(
                      width: 240.r,
                      height: 240.r,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [
                                  primary.withValues(alpha: 0.22 * glow),
                                  gold.withValues(alpha: 0.10 * glow),
                                  primary.withValues(alpha: 0),
                                ],
                                stops: const [0.0, 0.55, 1.0],
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 150.r,
                            height: 150.r,
                            child: Image.asset(AppImages.logo2, fit: BoxFit.contain),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Opacity(
              opacity: _taglineOpacity.value.clamp(0.0, 1.0),
              child: Transform.translate(
                offset: Offset(0, _taglineShift.value),
                child: AppText(
                  LocaleKeys.splash_tagline.tr(),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  textAlign: TextAlign.center,
                  color: AppColors.textSecondaryColor.themeColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
