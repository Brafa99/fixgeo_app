import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/theme/app_colors.dart';

class WorkerHelpButton extends StatelessWidget {
  const WorkerHelpButton({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () => showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        builder: (context) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 28),
            child: Text(
              message,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 16,
                height: 1.45,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
      tooltip: 'Más información',
      visualDensity: VisualDensity.compact,
      color: AppColors.primary,
      icon: const Icon(PhosphorIconsRegular.question, size: 19),
    );
  }
}
