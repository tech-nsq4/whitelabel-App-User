import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';

/// The row of dots under the onboarding illustration showing progress
/// through the slides — the active dot is wider and fully opaque.
class OnboardingDotsIndicator extends StatelessWidget {
  const OnboardingDotsIndicator({
    super.key,
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppColors.primaryColor.themeColor;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
        (j) => AnimatedContainer(
          duration: AppConstants.shortAnimationDuration,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: currentIndex == j ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: currentIndex == j
                ? primaryColor
                : primaryColor.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ),
    );
  }
}
