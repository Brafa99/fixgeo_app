import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';

class RegisterProgressIndicator extends StatelessWidget {
  const RegisterProgressIndicator({
    required this.currentStep,
    this.totalSteps = 3,
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
          final isCompleted = index < currentStep;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 8),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                height: 6,
                decoration: BoxDecoration(
                  color: isCompleted ? null : AppColors.border,
                  gradient: isCompleted ? AppGradients.brand : null,
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
