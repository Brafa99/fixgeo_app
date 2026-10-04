import 'package:flutter/material.dart';

import '../../core/constants/app_sizes.dart';
import '../../core/theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.onPressed,
    this.showArrow = true,
    this.compact = false,
    super.key,
  });

  final String label;
  final VoidCallback onPressed;
  final bool showArrow;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        elevation: 3,
        shadowColor: Colors.black26,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.primary,
        minimumSize: Size(0, compact ? 44 : 48),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 14 : AppSizes.spacingLg,
          vertical: compact ? 6 : AppSizes.spacingSm,
        ),
        shape: const StadiumBorder(),
        textStyle: TextStyle(
          fontSize: compact ? 12 : 14,
          fontWeight: FontWeight.w700,
        ),
      ),
      child: Text(
        showArrow ? '$label  →' : label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.center,
      ),
    );
  }
}
