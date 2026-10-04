import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class HomeSearchField extends StatelessWidget {
  const HomeSearchField({
    this.onTap,
    this.onChanged,
    this.onCameraTap,
    super.key,
  });

  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onCameraTap;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onTap: onTap,
      onChanged: onChanged,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: 'Ej. necesito un jardinero',
        hintStyle: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
        suffixIconConstraints: const BoxConstraints(minWidth: 64),
        suffixIcon: Padding(
          padding: const EdgeInsets.all(7),
          child: IconButton.filled(
            onPressed: onCameraTap ?? onTap,
            tooltip: 'Buscar servicio',
            style: IconButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            icon: const Icon(Icons.arrow_forward_rounded, size: 23),
          ),
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(color: AppColors.textSecondary),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.textSecondary,
            width: 1.4,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: const BorderSide(
            color: AppColors.primary,
            width: 1.8,
          ),
        ),
      ),
    );
  }
}
