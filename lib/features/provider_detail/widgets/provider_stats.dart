import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class ProviderStats extends StatelessWidget {
  const ProviderStats({
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    super.key,
  });

  final double rating;
  final int reviewCount;
  final double distanceKm;

  String get _distance {
    if (distanceKm < 1) return '${(distanceKm * 1000).round()} m';
    return '${distanceKm.toStringAsFixed(1)} km';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            icon: Icons.star_rounded,
            iconColor: AppColors.warning,
            value: rating.toStringAsFixed(1),
            label: 'Calificación',
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _StatCard(
            icon: Icons.reviews_outlined,
            iconColor: AppColors.purple,
            value: '$reviewCount',
            label: 'Reseñas',
          ),
        ),
        const SizedBox(width: 9),
        Expanded(
          child: _StatCard(
            icon: Icons.near_me_outlined,
            iconColor: AppColors.cyan,
            value: _distance,
            label: 'Distancia',
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 13),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: 18),
              const SizedBox(width: 4),
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            label,
            maxLines: 1,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
