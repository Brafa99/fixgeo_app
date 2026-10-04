import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/primary_button.dart';
import '../models/onboarding_item.dart';
import 'onboarding_indicator.dart';

class OnboardingBottomCard extends StatelessWidget {
  const OnboardingBottomCard({
    required this.item,
    required this.currentPage,
    required this.totalPages,
    required this.onContinue,
    super.key,
  });

  final OnboardingItem item;
  final int currentPage;
  final int totalPages;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 380;

        return Container(
          width: double.infinity,
          padding: EdgeInsets.fromLTRB(
            compact ? 18 : 24,
            compact ? 18 : 24,
            compact ? 14 : 18,
            compact ? 10 : 18,
          ),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: AppColors.onboardingGradient,
              stops: [0, 0.52, 1],
            ),
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSizes.radiusXl),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: compact ? 20 : 23,
                    fontWeight: FontWeight.w800,
                    height: 1.15,
                    letterSpacing: -0.35,
                  ),
                ),
                SizedBox(height: compact ? 8 : 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 390),
                  child: Text(
                    item.description,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: compact ? 12 : 14,
                      fontWeight: FontWeight.w400,
                      height: 1.35,
                    ),
                  ),
                ),
                SizedBox(height: compact ? 12 : 18),
                Row(
                  children: [
                    OnboardingIndicator(
                      currentPage: currentPage,
                      totalPages: totalPages,
                    ),
                    const SizedBox(width: AppSizes.spacingSm),
                    Expanded(
                      child: Align(
                        alignment: Alignment.centerRight,
                        child: PrimaryButton(
                          label: item.buttonText,
                          onPressed: onContinue,
                          compact: compact,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
