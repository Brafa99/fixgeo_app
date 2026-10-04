import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import 'registration_header.dart';

class CompanyRegistrationLayout extends StatelessWidget {
  const CompanyRegistrationLayout({
    required this.currentStep,
    required this.content,
    required this.bottomButton,
    this.onBack,
    this.contentPadding = const EdgeInsets.fromLTRB(24, 22, 24, 24),
    super.key,
  });

  final int currentStep;
  final Widget content;
  final Widget bottomButton;
  final VoidCallback? onBack;
  final EdgeInsets contentPadding;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints:
                const BoxConstraints(maxWidth: AppSizes.maxContentWidth),
            child: Column(
              children: [
                CompanyRegistrationHeader(
                  currentStep: currentStep,
                  onBack: onBack,
                ),
                Expanded(
                  child: SingleChildScrollView(
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: contentPadding,
                    child: content,
                  ),
                ),
                DecoratedBox(
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.shadow,
                        blurRadius: 20,
                        offset: Offset(0, -5),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(18, 14, 18, 16),
                    child: bottomButton,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
