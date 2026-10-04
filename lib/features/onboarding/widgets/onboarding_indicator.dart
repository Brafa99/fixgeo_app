import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';

class OnboardingIndicator extends StatelessWidget {
  const OnboardingIndicator({
    required this.currentPage,
    required this.totalPages,
    super.key,
  });

  final int currentPage;
  final int totalPages;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Página ${currentPage + 1} de $totalPages',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(totalPages, (index) {
          final isActive = index == currentPage;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            width: isActive
                ? AppSizes.onboardingActiveDot
                : AppSizes.onboardingInactiveDot,
            height: isActive
                ? AppSizes.onboardingActiveDot
                : AppSizes.onboardingInactiveDot,
            margin: const EdgeInsets.symmetric(horizontal: 2.5),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: isActive ? 1 : 0.48),
              shape: BoxShape.circle,
            ),
          );
        }),
      ),
    );
  }
}
