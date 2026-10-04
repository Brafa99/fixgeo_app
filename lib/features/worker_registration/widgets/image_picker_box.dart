import 'dart:io';

import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/theme/app_colors.dart';

class WorkerImagePickerBox extends StatelessWidget {
  const WorkerImagePickerBox({
    required this.imagePath,
    required this.isLoading,
    required this.onGalleryTap,
    required this.onCameraTap,
    required this.onRemoveTap,
    super.key,
  });

  final String? imagePath;
  final bool isLoading;
  final VoidCallback onGalleryTap;
  final VoidCallback onCameraTap;
  final VoidCallback onRemoveTap;

  @override
  Widget build(BuildContext context) {
    if (imagePath != null) {
      return Column(
        children: [
          Container(
            height: 178,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.border),
            ),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(File(imagePath!), fit: BoxFit.cover),
                Positioned(
                  top: 10,
                  right: 10,
                  child: IconButton.filled(
                    onPressed: onRemoveTap,
                    tooltip: 'Eliminar imagen',
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.error,
                    ),
                    icon: const Icon(PhosphorIconsRegular.trash, size: 20),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onGalleryTap,
                  icon: const Icon(PhosphorIconsRegular.image),
                  label: const Text('Cambiar'),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onCameraTap,
                  icon: const Icon(PhosphorIconsRegular.camera),
                  label: const Text('Nueva foto'),
                ),
              ),
            ],
          ),
        ],
      );
    }

    return Container(
      height: 140,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.primarySoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _PickerAction(
                  icon: PhosphorIconsRegular.image,
                  label: 'Galería',
                  onTap: onGalleryTap,
                ),
                const SizedBox(width: 24),
                _PickerAction(
                  icon: PhosphorIconsRegular.camera,
                  label: 'Cámara',
                  onTap: onCameraTap,
                ),
              ],
            ),
    );
  }
}

class _PickerAction extends StatelessWidget {
  const _PickerAction({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.blue),
              ),
              child: Icon(icon, color: AppColors.primary, size: 26),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
