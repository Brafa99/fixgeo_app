import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';

enum WorkerOrdersFilter { all, newOrders, accepted }

class OrderFilterTabs extends StatelessWidget {
  const OrderFilterTabs({
    required this.selectedFilter,
    required this.onFilterChanged,
    required this.allCount,
    required this.newCount,
    required this.acceptedCount,
    super.key,
  });

  final WorkerOrdersFilter selectedFilter;
  final ValueChanged<WorkerOrdersFilter> onFilterChanged;
  final int allCount;
  final int newCount;
  final int acceptedCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _FilterTabButton(
            label: 'Todas ($allCount)',
            isSelected: selectedFilter == WorkerOrdersFilter.all,
            onTap: () => onFilterChanged(WorkerOrdersFilter.all),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _FilterTabButton(
            label: 'Nuevas ($newCount)',
            isSelected: selectedFilter == WorkerOrdersFilter.newOrders,
            onTap: () => onFilterChanged(WorkerOrdersFilter.newOrders),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _FilterTabButton(
            label: 'Aceptadas ($acceptedCount)',
            isSelected: selectedFilter == WorkerOrdersFilter.accepted,
            onTap: () => onFilterChanged(WorkerOrdersFilter.accepted),
          ),
        ),
      ],
    );
  }
}

class _FilterTabButton extends StatelessWidget {
  const _FilterTabButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: isSelected,
      label: label,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        height: 44,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
          boxShadow: isSelected ? AppShadows.card : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(16),
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: isSelected ? Colors.white : AppColors.textSecondary,
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
