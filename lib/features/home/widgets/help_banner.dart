import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_gradients.dart';
import '../../../core/utils/app_image_cache.dart';
import '../../../shared/widgets/optimized_asset_image.dart';
import '../../../shared/widgets/primary_button.dart';

class HelpBanner extends StatelessWidget {
  const HelpBanner({required this.onCreateRequest, super.key});

  final VoidCallback onCreateRequest;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 350;
        final imageWidth = isCompact ? 92.0 : 126.0;

        return Container(
          constraints: const BoxConstraints(minHeight: 180),
          decoration: BoxDecoration(
            gradient: AppGradients.primary,
            borderRadius: BorderRadius.circular(24),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned(
                right: -30,
                top: -40,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: const BoxDecoration(
                    color: Colors.white12,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 8, 0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 18),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              AppStrings.helpTitle,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: AppSizes.spacingSm),
                            const Text(
                              AppStrings.helpDescription,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 12),
                            PrimaryButton(
                              label: AppStrings.createRequest,
                              onPressed: onCreateRequest,
                              showArrow: false,
                              compact: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSizes.spacingSm),
                    OptimizedAssetImage(
                      assetName: AppAssets.worker,
                      cacheWidth: AppImageDecodeSize.illustration,
                      width: imageWidth,
                      height: 168,
                      alignment: Alignment.bottomCenter,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
