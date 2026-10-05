import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/utils/app_image_cache.dart';
import '../../../models/service_model.dart';
import '../../../shared/widgets/optimized_asset_image.dart';

class SelectedServiceCard extends StatelessWidget {
  const SelectedServiceCard({required this.service, super.key});

  final ServiceModel service;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 58,
            height: 58,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(16),
            ),
            child: service.icon.startsWith('assets/')
                ? OptimizedAssetImage(
                    assetName: service.icon,
                    cacheWidth: AppImageDecodeSize.category,
                    width: 58,
                    height: 58,
                    fit: BoxFit.cover,
                  )
                : const Icon(
                    Icons.home_repair_service_rounded,
                    color: AppColors.primary,
                    size: 30,
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  service.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                const Text(
                  'Cuéntanos qué necesitas',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14,
                    height: 1.35,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
