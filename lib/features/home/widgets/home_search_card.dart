import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/utils/app_image_cache.dart';
import '../../../shared/widgets/optimized_asset_image.dart';
import '../models/service_category.dart';
import 'home_search_field.dart';

class HomeSearchCard extends StatefulWidget {
  const HomeSearchCard({
    required this.categories,
    this.onSearchTap,
    this.onSearchChanged,
    this.onSearchSubmit,
    super.key,
  });

  final List<ServiceCategory> categories;
  final VoidCallback? onSearchTap;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchSubmit;

  @override
  State<HomeSearchCard> createState() => _HomeSearchCardState();
}

class _HomeSearchCardState extends State<HomeSearchCard> {
  int _selectedIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12),
      padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(34),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '¿Te ayudo a solucionar algo?',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 23,
              fontWeight: FontWeight.w900,
              height: 1.15,
              letterSpacing: -0.55,
            ),
          ),
          const SizedBox(height: 9),
          const Row(
            children: [
              Icon(
                Icons.location_on_rounded,
                color: Color(0xFF98A2B3),
                size: 20,
              ),
              SizedBox(width: 6),
              Text(
                'Bolivia',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          HomeSearchField(
            onTap: widget.onSearchTap,
            onChanged: widget.onSearchChanged,
            onCameraTap: widget.onSearchSubmit,
          ),
          const SizedBox(height: 18),
          SizedBox(
            height: 104,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: widget.categories.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) => _QuickCategory(
                category: widget.categories[index],
                isSelected: index == _selectedIndex,
                onTap: () => setState(() => _selectedIndex = index),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickCategory extends StatelessWidget {
  const _QuickCategory({
    required this.category,
    required this.isSelected,
    required this.onTap,
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
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            width: 94,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              color: AppColors.cyanSoft,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(
                color: isSelected ? AppColors.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: OptimizedAssetImage(
                assetName: category.image,
                cacheWidth: AppImageDecodeSize.category,
                width: 88,
                height: 98,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
