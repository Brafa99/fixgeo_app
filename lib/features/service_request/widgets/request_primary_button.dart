import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';

class RequestPrimaryButton extends StatelessWidget {
  const RequestPrimaryButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.trailingIcon = Icons.arrow_forward_rounded,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData trailingIcon;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null && !isLoading;
    return Container(
      height: AppSizes.buttonHeight,
      decoration: BoxDecoration(
        gradient: enabled ? AppGradients.primary : null,
        color: enabled ? null : AppColors.disabled,
        borderRadius: BorderRadius.circular(AppSizes.radiusMd),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: enabled ? onPressed : null,
          borderRadius: BorderRadius.circular(AppSizes.radiusMd),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (isLoading)
                  const SizedBox.square(
                    dimension: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                else ...[
                  const SizedBox(width: 24),
                  Expanded(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  Icon(trailingIcon, color: Colors.white, size: 22),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
