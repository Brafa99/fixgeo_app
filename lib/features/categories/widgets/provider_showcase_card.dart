import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/utils/app_image_cache.dart';
import '../../../shared/widgets/optimized_asset_image.dart';
import '../models/provider_showcase_item.dart';

class ProviderShowcaseCard extends StatelessWidget {
  const ProviderShowcaseCard({
    required this.provider,
    required this.onTap,
    super.key,
  });

  final ProviderShowcaseItem provider;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: '${provider.typeLabel}: ${provider.name}',
      child: Material(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Container(
            width: 188,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: AppColors.border),
              boxShadow: AppShadows.card,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 112,
                  width: double.infinity,
                  child: _ProviderImage(provider: provider),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 10, 12, 11),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                provider.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            const SizedBox(width: 5),
                            const Icon(
                              Icons.star_rounded,
                              size: 15,
                              color: AppColors.warning,
                            ),
                            Text(
                              provider.rating.toStringAsFixed(1),
                              style: const TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 11,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 7),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: provider.typeLabel == 'Empresa'
                                ? AppColors.purpleSoft
                                : AppColors.cyanSoft,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            provider.typeLabel,
                            style: const TextStyle(
                              color: AppColors.primary,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        Text(
                          provider.details,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on_rounded,
                              size: 13,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 3),
                            Expanded(
                              child: Text(
                                provider.location,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProviderImage extends StatelessWidget {
  const _ProviderImage({required this.provider});

  final ProviderShowcaseItem provider;

  @override
  Widget build(BuildContext context) {
    final image = provider.profileImage;
    if (image.startsWith('assets/')) {
      return Image.asset(image, fit: BoxFit.cover);
    }
    if (image.startsWith('http') && !image.contains('.example')) {
      return Image.network(
        image,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallback(),
      );
    }
    return _fallback();
  }

  Widget _fallback() {
    return ColoredBox(
      color: AppColors.primarySoft,
      child: OptimizedAssetImage(
        assetName: provider.fallbackAsset,
        cacheWidth: AppImageDecodeSize.avatar,
        fit: BoxFit.cover,
        alignment: Alignment.topCenter,
      ),
    );
  }
}
