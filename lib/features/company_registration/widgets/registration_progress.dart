import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';

class CompanyRegistrationProgress extends StatelessWidget {
  const CompanyRegistrationProgress({
    required this.currentStep,
    this.totalSteps = 5,
    super.key,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Paso $currentStep de $totalSteps',
      child: Row(
        children: List.generate(totalSteps, (index) {
          final active = index < currentStep;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 6),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 240),
                height: 6,
                decoration: BoxDecoration(
                  color: active ? null : AppColors.border,
                  gradient: active ? AppGradients.brand : null,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
