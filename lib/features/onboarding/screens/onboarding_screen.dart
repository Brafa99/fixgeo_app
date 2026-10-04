import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/route_names.dart';
import '../models/onboarding_item.dart';
import '../widgets/onboarding_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  static const _items = <OnboardingItem>[
    OnboardingItem(
      title: AppStrings.onboardingWelcomeTitle,
      description: AppStrings.onboardingWelcomeDescription,
      image: AppAssets.onboardingStart,
      buttonText: AppStrings.continueLabel,
    ),
    OnboardingItem(
      title: AppStrings.onboardingHowTitle,
      description: AppStrings.onboardingHowDescription,
      image: AppAssets.megaphone,
      buttonText: AppStrings.continueLabel,
      visual: OnboardingVisual.howItWorks,
    ),
    OnboardingItem(
      title: AppStrings.onboardingProviderTitle,
      description: AppStrings.onboardingProviderDescription,
      image: AppAssets.workers,
      buttonText: AppStrings.continueLabel,
      visual: OnboardingVisual.providers,
    ),
    OnboardingItem(
      title: AppStrings.onboardingRealityTitle,
      description: AppStrings.onboardingRealityDescription,
      image: AppAssets.worker,
      buttonText: AppStrings.continueLabel,
    ),
    OnboardingItem(
      title: AppStrings.onboardingAboutTitle,
      description: AppStrings.onboardingAboutDescription,
      image: AppAssets.servicesPhone,
      buttonText: AppStrings.getStarted,
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _openHome() {
    Navigator.pushReplacementNamed(context, RouteNames.home);
  }

  void _continue() {
    if (_currentPage == _items.length - 1) {
      _openHome();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView.builder(
        controller: _pageController,
        itemCount: _items.length,
        onPageChanged: (index) => setState(() => _currentPage = index),
        itemBuilder: (context, index) => OnboardingPage(
          item: _items[index],
          currentPage: index,
          totalPages: _items.length,
          onSkip: _openHome,
          onContinue: _continue,
        ),
      ),
    );
  }
}
