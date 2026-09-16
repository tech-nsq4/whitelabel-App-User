enum OnboardingIllustrationType {
  welcome,
  telemed,
  pharmacy,
  family,
}

class OnboardingSlideData {
  const OnboardingSlideData({
    this.illustration = OnboardingIllustrationType.welcome,
    this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  final OnboardingIllustrationType illustration;
  final String? imageUrl;
  final String title;
  final String subtitle;

  bool get hasText => title.isNotEmpty;
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
}
