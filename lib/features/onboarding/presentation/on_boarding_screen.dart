import 'package:easy_localization/easy_localization.dart';
import 'package:vivacare_white_label/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text.dart';
import 'widgets/onboarding_dots_indicator.dart';
import 'widgets/onboarding_illustration.dart';
import 'widgets/onboarding_slide_data.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  List<OnboardingSlideData> _slides = [];

  List<OnboardingSlideData> _buildSlides() {
    return [
      OnboardingSlideData(
        illustration: OnboardingIllustrationType.welcome,
        title: LocaleKeys.onboarding_slide1_title.tr(),
        subtitle: LocaleKeys.onboarding_slide1_subtitle.tr(),
      ),
      OnboardingSlideData(
        illustration: OnboardingIllustrationType.telemed,
        title: LocaleKeys.onboarding_slide2_title.tr(),
        subtitle: LocaleKeys.onboarding_slide2_subtitle.tr(),
      ),
      OnboardingSlideData(
        illustration: OnboardingIllustrationType.pharmacy,
        title: LocaleKeys.onboarding_slide3_title.tr(),
        subtitle: LocaleKeys.onboarding_slide3_subtitle.tr(),
      ),
      OnboardingSlideData(
        illustration: OnboardingIllustrationType.family,
        title: LocaleKeys.onboarding_slide4_title.tr(),
        subtitle: LocaleKeys.onboarding_slide4_subtitle.tr(),
      ),
    ];
  }

  bool get _isLast => _currentPage == _slides.length - 1;

  void _nextPage() {
    if (_isLast) {
      _finish();
    } else {
      _pageController.nextPage(
        duration: AppConstants.defaultAnimationDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  void _finish() {
    getIt<LocalStorage>().setOnboardingSeen();
    Navigator.pushNamedAndRemoveUntil(
        context, Routes.loginScreen, (_) => false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _slides = _buildSlides();
    // Guard: if page jumped beyond new slides count, clamp it
    if (_currentPage >= _slides.length) _currentPage = _slides.length - 1;
    final slides = _slides;
    final currentSlide = slides[_currentPage];

    final accentGold = AppColors.accentGold.themeColor;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: 20.paddingHorizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Logo ────────────────────────────────────────────────────
              Center(
                child: Image.asset(
                  AppImages.logo3,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
              ),

              // ── Illustration card (PageView) ─────────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: slides.length,
                  onPageChanged: (i) => setState(() => _currentPage = i),
                  itemBuilder: (_, i) => Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      OnboardingIllustration(illustration: slides[i].illustration),
                      32.height,
                      OnboardingDotsIndicator(
                        count: slides.length,
                        currentIndex: _currentPage,
                      ),
                      24.height,
                      AnimatedOpacity(
                        opacity: currentSlide.hasText ? 1.0 : 0.0,
                        duration: AppConstants.defaultAnimationDuration,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: AppConstants.defaultPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              AppText(
                                currentSlide.title,
                                isHeading: true,
                                color: AppColors.textPrimaryColor.themeColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.sp,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 12.h),
                              AppText(
                                currentSlide.subtitle,
                                color: AppColors.textSecondaryColor.themeColor,
                                height: 1.5,
                                fontSize: 15.sp,
                                maxLines: 4,
                                fontWeight: FontWeight.w400,
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Primary button ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding),
                child: CustomButton(
                  title: _isLast
                      ? LocaleKeys.onboarding_getStarted.tr()
                      : LocaleKeys.onboarding_next.tr(),
                  onTap: _nextPage,
                  color: _isLast ? accentGold : null,
                  borderColor: _isLast ? accentGold : null,
                ),
              ),

              // ── Skip ─────────────────────────────────────────────────────
              Center(
                child: TextButton(
                  onPressed: _finish,
                  child: AppText(
                    LocaleKeys.onboarding_skip.tr(),
                    color: AppColors.mutedColor.themeColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
