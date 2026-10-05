import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/provider_review_item.dart';

class ProviderReviewsSection extends StatelessWidget {
  const ProviderReviewsSection({required this.reviews, super.key});

  final List<ProviderReviewItem> reviews;

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return const Text(
        'Este prestador todavía no tiene reseñas visibles.',
        style: TextStyle(color: AppColors.textSecondary, fontSize: 14),
      );
    }
    return Column(
      children: [
        for (var index = 0; index < reviews.length; index++) ...[
          _ReviewCard(item: reviews[index]),
          if (index < reviews.length - 1) const SizedBox(height: 11),
        ],
      ],
    );
  }
}

class _ReviewCard extends StatelessWidget {
  const _ReviewCard({required this.item});

  final ProviderReviewItem item;

  String get _date {
    final date = item.review.createdAt;
    return '${date.day.toString().padLeft(2, '0')}/'
        '${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  item.clientName,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              const Icon(
                Icons.star_rounded,
                color: AppColors.warning,
                size: 17,
              ),
              const SizedBox(width: 3),
              Text(
                item.review.rating.toStringAsFixed(1),
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _date,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 11,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            item.review.comment,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 13,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}
