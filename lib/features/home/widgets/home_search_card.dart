import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../models/service_category.dart';
import 'category_card.dart';
import 'home_search_field.dart';

class HomeSearchCard extends StatefulWidget {
  const HomeSearchCard({
    required this.categories,
    this.onSearchTap,
    this.onSearchChanged,
    this.onSearchSubmit,
    this.onCategoryTap,
    super.key,
  });

  final List<ServiceCategory> categories;
  final VoidCallback? onSearchTap;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onSearchSubmit;
  final ValueChanged<ServiceCategory>? onCategoryTap;

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
              itemBuilder: (context, index) => CategoryCard(
                key: ValueKey('home-category-${widget.categories[index].id}'),
                name: widget.categories[index].name,
                image: widget.categories[index].image,
                isSelected: index == _selectedIndex,
                variant: CategoryCardVariant.compact,
                size: 94,
                onTap: () {
                  setState(() => _selectedIndex = index);
                  widget.onCategoryTap?.call(widget.categories[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
