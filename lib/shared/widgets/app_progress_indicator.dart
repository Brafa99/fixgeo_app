import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({
    required this.currentStep,
    required this.totalSteps,
    super.key,
  }) : assert(currentStep > 0 && currentStep <= totalSteps);

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          '${AppStrings.step} $currentStep ${AppStrings.ofLabel} $totalSteps',
      child: LinearProgressIndicator(value: currentStep / totalSteps),
    );
  }
}
