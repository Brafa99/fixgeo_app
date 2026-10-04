import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../models/provider_preview.dart';
import 'provider_card.dart';
import 'section_header.dart';

class RecommendedProvidersSection extends StatelessWidget {
  const RecommendedProvidersSection({required this.providers, super.key});

  final List<ProviderPreview> providers;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSizes.spacingLg),
          child: SectionHeader(
            title: AppStrings.recommendedProviders,
            actionLabel: AppStrings.seeAll,
            onAction: () {},
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 154,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSizes.spacingLg,
              vertical: 2,
            ),
            scrollDirection: Axis.horizontal,
            itemCount: providers.length,
            separatorBuilder: (context, index) =>
                const SizedBox(width: AppSizes.spacingMd),
            itemBuilder: (context, index) => ProviderCard(
              provider: providers[index],
              onTap: () {},
            ),
          ),
        ),
      ],
    );
  }
}
