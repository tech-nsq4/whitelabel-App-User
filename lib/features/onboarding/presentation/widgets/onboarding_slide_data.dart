/// The visual theme each onboarding page is illustrated with.
///
/// Mapped to a concrete [Widget] by `OnboardingIllustration` — kept as an
/// enum here so the slide data stays presentation-agnostic.
enum OnboardingIllustrationType {
  welcome,
  telemed,
  pharmacy,
  family,
}

/// One page of the onboarding flow: what it looks like + what it says.
class OnboardingSlideData {
  const OnboardingSlideData({
    required this.illustration,
    required this.title,
    required this.subtitle,
  });

  final OnboardingIllustrationType illustration;
  final String title;
  final String subtitle;

  bool get hasText => title.isNotEmpty;
}
