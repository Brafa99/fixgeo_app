import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class RequestPhotoPicker extends StatelessWidget {
  const RequestPhotoPicker({
    required this.imagePaths,
    required this.isLoading,
    required this.canAddMore,
    required this.onAdd,
    required this.onRemove,
    super.key,
  });

  final List<String> imagePaths;
  final bool isLoading;
  final bool canAddMore;
  final VoidCallback onAdd;
  final ValueChanged<String> onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 102,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: imagePaths.length + (canAddMore ? 1 : 0),
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          if (canAddMore && index == 0) {
            return _AddPhotoTile(isLoading: isLoading, onTap: onAdd);
          }
          final imageIndex = index - (canAddMore ? 1 : 0);
          final path = imagePaths[imageIndex];
          return _PhotoPreview(path: path, onRemove: () => onRemove(path));
        },
      ),
    );
  }
}

class _AddPhotoTile extends StatelessWidget {
  const _AddPhotoTile({required this.isLoading, required this.onTap});

  final bool isLoading;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primarySoft,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        key: const ValueKey('add-request-photo'),
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 102,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: isLoading
              ? const Center(
                  child: SizedBox.square(
                    dimension: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                )
              : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      color: AppColors.primary,
                      size: 28,
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Agregar foto',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _PhotoPreview extends StatelessWidget {
  const _PhotoPreview({required this.path, required this.onRemove});

  final String path;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 102,
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.file(
                File(path),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const ColoredBox(
                  color: AppColors.primarySoft,
                  child: Center(
                    child: Icon(
                      Icons.image_outlined,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 5,
            right: 5,
            child: IconButton.filled(
              key: ValueKey('remove-request-photo-$path'),
              onPressed: onRemove,
              tooltip: 'Eliminar foto',
              constraints: const BoxConstraints.tightFor(
                width: 30,
                height: 30,
              ),
              padding: EdgeInsets.zero,
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.error,
              ),
              icon: const Icon(Icons.close_rounded, size: 18),
            ),
          ),
        ],
      ),
    );
  }
}
