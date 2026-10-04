import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';

class WorkerPrimaryButton extends StatelessWidget {
  const WorkerPrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final isEnabled = onPressed != null && !isLoading;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: double.infinity,
      height: 54,
      decoration: BoxDecoration(
        color: isEnabled ? null : AppColors.disabled,
        gradient: isEnabled ? AppGradients.brand : null,
        borderRadius: BorderRadius.circular(18),
        boxShadow: isEnabled
            ? const [
                BoxShadow(
                  color: Color(0x267447F5),
                  blurRadius: 16,
                  offset: Offset(0, 7),
                ),
              ]
            : null,
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          disabledBackgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          disabledForegroundColor: Colors.white70,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
        child: isLoading
            ? const SizedBox.square(
                dimension: AppSizes.loadingIndicator,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: AppSizes.loadingStroke,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
              ),
      ),
    );
  }
}
