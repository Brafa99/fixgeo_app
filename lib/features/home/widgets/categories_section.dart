import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../models/service_category.dart';
import 'category_card.dart';

class CategoriesSection extends StatefulWidget {
  const CategoriesSection({required this.categories, super.key});

  final List<ServiceCategory> categories;

  @override
  State<CategoriesSection> createState() => _CategoriesSectionState();
}

class _CategoriesSectionState extends State<CategoriesSection> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSizes.spacingLg),
          child: Text(
            AppStrings.categories,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 100,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacingLg,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: widget.categories.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSizes.spacingSm),
            itemBuilder: (context, index) => CategoryCard(
              name: widget.categories[index].name,
              image: widget.categories[index].image,
              isSelected: index == _selectedIndex,
              variant: CategoryCardVariant.compact,
              onTap: () => setState(() => _selectedIndex = index),
            ),
          ),
        ),
      ],
    );
  }
}
