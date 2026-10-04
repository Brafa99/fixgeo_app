import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class WorkerStepIntro extends StatelessWidget {
  const WorkerStepIntro({
    required this.title,
    this.description,
    this.helpButton,
    super.key,
  });

  final String title;
  final String? description;
  final Widget? helpButton;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 27,
                  fontWeight: FontWeight.w900,
                  height: 1.08,
                  letterSpacing: -0.6,
                ),
              ),
            ),
            if (helpButton != null) helpButton!,
          ],
        ),
        if (description != null) ...[
          const SizedBox(height: 8),
          Text(
            description!,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 15,
              height: 1.4,
            ),
          ),
        ],
      ],
    );
  }
}
