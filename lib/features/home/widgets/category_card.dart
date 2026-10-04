import 'package:flutter/material.dart';

import '../../../core/utils/app_image_cache.dart';
import '../../../core/theme/app_colors.dart';
import '../../../shared/widgets/optimized_asset_image.dart';
import '../models/service_category.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({
    required this.category,
    required this.isSelected,
    required this.onTap,
    super.key,
  });

  final ServiceCategory category;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: category.name,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: 100,
            height: 100,
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected ? AppColors.blue : Colors.transparent,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(17),
              child: OptimizedAssetImage(
                assetName: category.image,
                cacheWidth: AppImageDecodeSize.category,
                width: 96,
                height: 96,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
