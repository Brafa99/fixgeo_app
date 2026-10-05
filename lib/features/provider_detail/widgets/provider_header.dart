import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../models/provider_detail_data.dart';

class ProviderHeader extends StatelessWidget {
  const ProviderHeader({required this.provider, super.key});

  final ProviderDetailData provider;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _ProviderAvatar(provider: provider),
        const SizedBox(height: 14),
        Text(
          provider.name,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 7),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.primarySoft,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Text(
            provider.typeLabel,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: provider.isAvailable
                ? AppColors.successSoft
                : AppColors.warningSoft,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.circle,
                color: provider.isAvailable
                    ? AppColors.success
                    : AppColors.warning,
                size: 9,
              ),
              const SizedBox(width: 6),
              Text(
                provider.isAvailable ? 'Disponible' : 'No disponible',
                style: TextStyle(
                  color: provider.isAvailable
                      ? AppColors.success
                      : AppColors.warning,
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProviderAvatar extends StatelessWidget {
  const _ProviderAvatar({required this.provider});

  final ProviderDetailData provider;

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      color: AppColors.primarySoft,
      alignment: Alignment.center,
      child: Text(
        provider.initials,
        style: const TextStyle(
          color: AppColors.primary,
          fontSize: 30,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
    return Container(
      width: 108,
      height: 108,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primarySoft,
        border: Border.all(color: AppColors.surface, width: 4),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: provider.profileImage.trim().isEmpty
          ? fallback
          : Image.network(
              provider.profileImage,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => fallback,
            ),
    );
  }
}
