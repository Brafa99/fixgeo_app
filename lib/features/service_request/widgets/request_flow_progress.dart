import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class RequestFlowProgress extends StatelessWidget {
  const RequestFlowProgress({
    required this.currentStep,
    this.totalSteps = 3,
    super.key,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    const activeColors = [
      AppColors.cyan,
      AppColors.purple,
      AppColors.pink,
    ];
    return Row(
      children: List.generate(totalSteps, (index) {
        final active = index < currentStep;
        return Expanded(
          child: Container(
            height: 4,
            margin: EdgeInsets.only(right: index == totalSteps - 1 ? 0 : 6),
            decoration: BoxDecoration(
              color: active
                  ? activeColors[index.clamp(0, activeColors.length - 1)]
                  : AppColors.border,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }),
    );
  }
}
