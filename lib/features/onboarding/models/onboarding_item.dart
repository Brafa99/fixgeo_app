enum OnboardingVisual {
  standard,
  howItWorks,
  providers,
}

class OnboardingItem {
  const OnboardingItem({
    required this.title,
    required this.description,
    required this.image,
    required this.buttonText,
    this.visual = OnboardingVisual.standard,
  });

  final String title;
  final String description;
  final String image;
  final String buttonText;
  final OnboardingVisual visual;
}
