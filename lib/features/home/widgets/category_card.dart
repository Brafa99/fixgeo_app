import 'package:flutter/material.dart';

import '../../../core/utils/app_image_cache.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../shared/widgets/optimized_asset_image.dart';

enum CategoryCardVariant { compact, grid }

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    required this.name,
    required this.image,
    required this.isSelected,
    required this.onTap,
    this.variant = CategoryCardVariant.grid,
    this.size,
    super.key,
  });

  final String name;
  final String image;
  final bool isSelected;
  final VoidCallback onTap;
  final CategoryCardVariant variant;
  final double? size;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: name,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: variant == CategoryCardVariant.compact
              ? _CompactCategoryCard(
                  image: image,
                  isSelected: isSelected,
                  size: size ?? 100,
                )
              : _GridCategoryCard(
                  name: name,
                  image: image,
                  isSelected: isSelected,
                ),
        ),
      ),
    );
  }
}

class _CompactCategoryCard extends StatelessWidget {
  const _CompactCategoryCard({
    required this.image,
    required this.isSelected,
    required this.size,
  });

  final String image;
  final bool isSelected;
  final double size;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      width: size,
      height: size,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.cyanSoft,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isSelected ? AppColors.blue : Colors.transparent,
          width: 2,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(17),
        child: OptimizedAssetImage(
          assetName: image,
          cacheWidth: AppImageDecodeSize.category,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _GridCategoryCard extends StatelessWidget {
  const _GridCategoryCard({
    required this.name,
    required this.image,
    required this.isSelected,
  });

  final String name;
  final String image;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isSelected ? AppColors.blue : AppColors.border,
          width: isSelected ? 2 : 1,
        ),
        boxShadow: AppShadows.card,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Expanded(
            child: SizedBox(
              width: double.infinity,
              child: OptimizedAssetImage(
                assetName: image,
                cacheWidth: AppImageDecodeSize.category,
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
            child: Text(
              name,
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 14,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
