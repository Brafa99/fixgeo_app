import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_image_cache.dart';
import '../../../shared/widgets/optimized_asset_image.dart';
import '../models/onboarding_item.dart';
import 'onboarding_bottom_card.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({
    required this.item,
    required this.currentPage,
    required this.totalPages,
    required this.onSkip,
    required this.onContinue,
    super.key,
  });

  final OnboardingItem item;
  final int currentPage;
  final int totalPages;
  final VoidCallback onSkip;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 380;
        final cardHeight = compact
            ? math.min(math.max(constraints.maxHeight * 0.41, 240.0), 270.0)
            : math.min(
                math.max(constraints.maxHeight * 0.36, 220.0),
                272.0,
              );

        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFF7FAFF), Color(0xFFFFF8FF)],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: SafeArea(
                  bottom: false,
                  child: Stack(
                    children: [
                      const Positioned(
                        top: 56,
                        left: -56,
                        child: _BackgroundGlow(
                          size: 180,
                          color: Color(0x1712C9E8),
                        ),
                      ),
                      const Positioned(
                        right: -60,
                        bottom: 10,
                        child: _BackgroundGlow(
                          size: 210,
                          color: Color(0x167947F5),
                        ),
                      ),
                      Positioned.fill(
                        top: 48,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                          child: _OnboardingVisual(item: item),
                        ),
                      ),
                      Positioned(
                        top: AppSizes.spacingSm,
                        right: AppSizes.spacingMd,
                        child: _SkipButton(onPressed: onSkip),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: cardHeight,
                child: OnboardingBottomCard(
                  item: item,
                  currentPage: currentPage,
                  totalPages: totalPages,
                  onContinue: onContinue,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SkipButton extends StatelessWidget {
  const _SkipButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: AppColors.primary,
        backgroundColor: Colors.white.withValues(alpha: 0.88),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        shape: const StadiumBorder(),
        elevation: 1,
        shadowColor: Colors.black12,
        textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
      ),
      child: const Text(AppStrings.skip),
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
    );
  }
}

class _OnboardingVisual extends StatelessWidget {
  const _OnboardingVisual({required this.item});

  final OnboardingItem item;

  @override
  Widget build(BuildContext context) {
    return switch (item.visual) {
      OnboardingVisual.howItWorks => const _HowItWorksVisual(),
      OnboardingVisual.providers => _ProvidersVisual(image: item.image),
      OnboardingVisual.standard => _StandardVisual(image: item.image),
    };
  }
}

class _StandardVisual extends StatelessWidget {
  const _StandardVisual({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 470, maxHeight: 470),
        child: OptimizedAssetImage(
          assetName: image,
          cacheWidth: AppImageDecodeSize.illustration,
        ),
      ),
    );
  }
}

class _HowItWorksVisual extends StatelessWidget {
  const _HowItWorksVisual();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 430),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;
            final megaphoneSize = math.min(width * 0.4, 150.0);

            return Stack(
              alignment: Alignment.topCenter,
              children: [
                Positioned(
                  top: 4,
                  left: width * 0.04,
                  child: Transform.rotate(
                    angle: -0.2,
                    child: OptimizedAssetImage(
                      assetName: AppAssets.paintBrush,
                      cacheWidth: AppImageDecodeSize.decorative,
                      width: math.min(width * 0.24, 88.0),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  left: width * 0.22,
                  right: 4,
                  child: const _RequestBubble(),
                ),
                Positioned(
                  top: constraints.maxHeight * 0.25,
                  child: OptimizedAssetImage(
                    assetName: AppAssets.megaphone,
                    cacheWidth: AppImageDecodeSize.decorative,
                    width: megaphoneSize,
                    height: megaphoneSize,
                  ),
                ),
                Positioned(
                  left: width * 0.16,
                  top: constraints.maxHeight * 0.52,
                  child: const Icon(
                    Icons.south_west_rounded,
                    color: AppColors.blue,
                    size: 24,
                  ),
                ),
                Positioned(
                  right: width * 0.16,
                  top: constraints.maxHeight * 0.52,
                  child: const Icon(
                    Icons.south_east_rounded,
                    color: AppColors.purple,
                    size: 24,
                  ),
                ),
                const Align(
                  alignment: Alignment.bottomCenter,
                  child: _ProviderCards(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _RequestBubble extends StatelessWidget {
  const _RequestBubble();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.purple, AppColors.pink],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
              color: Color(0x287947F5), blurRadius: 14, offset: Offset(0, 6)),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.requestTitle,
            style: TextStyle(
              color: Colors.white,
              fontSize: 13,
              fontWeight: FontWeight.w700,
              height: 1.1,
            ),
          ),
          SizedBox(height: 3),
          Text(
            AppStrings.requestLocation,
            style: TextStyle(color: Colors.white70, fontSize: 9),
          ),
        ],
      ),
    );
  }
}

class _ProviderCards extends StatelessWidget {
  const _ProviderCards();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        _ProviderCard(
          image: AppAssets.client,
          name: 'Matías G.',
          specialty: 'Pintura',
        ),
        SizedBox(width: 8),
        _ProviderCard(
          image: AppAssets.provider,
          name: 'Rubén M.',
          specialty: 'Servicios',
          selected: true,
        ),
        SizedBox(width: 8),
        _ProviderCard(
          image: AppAssets.client,
          name: 'Carlos L.',
          specialty: 'Reparaciones',
        ),
      ],
    );
  }
}

class _ProviderCard extends StatelessWidget {
  const _ProviderCard({
    required this.image,
    required this.name,
    required this.specialty,
    this.selected = false,
  });

  final String image;
  final String name;
  final String specialty;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 82,
      padding: const EdgeInsets.fromLTRB(5, 5, 5, 7),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? AppColors.blue : AppColors.border,
          width: selected ? 2 : 1,
        ),
        boxShadow: const [
          BoxShadow(
              color: Color(0x16083B8C), blurRadius: 8, offset: Offset(0, 3)),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xFFEAF7FF),
                backgroundImage: optimizedAssetProvider(
                  image,
                  cacheWidth: AppImageDecodeSize.avatar,
                ),
              ),
              if (selected)
                const Positioned(
                  top: -3,
                  right: -5,
                  child: CircleAvatar(
                    radius: 8,
                    backgroundColor: AppColors.blue,
                    child: Icon(Icons.check, color: Colors.white, size: 11),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            name,
            maxLines: 1,
            style: const TextStyle(
              color: AppColors.textPrimary,
              fontSize: 9,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            specialty,
            maxLines: 1,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 7,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProvidersVisual extends StatelessWidget {
  const _ProvidersVisual({required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 430),
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Positioned.fill(
              top: 64,
              child: OptimizedAssetImage(
                assetName: image,
                cacheWidth: AppImageDecodeSize.illustration,
              ),
            ),
            Positioned(
              top: 8,
              left: 8,
              right: 54,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.cyan, AppColors.purple],
                  ),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x221889F2),
                      blurRadius: 14,
                      offset: Offset(0, 5),
                    ),
                  ],
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.availableJob,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      AppStrings.availableJobDetail,
                      style: TextStyle(color: Colors.white70, fontSize: 10),
                    ),
                  ],
                ),
              ),
            ),
            const Positioned(
              top: 22,
              right: 10,
              child: Icon(
                Icons.notifications_active_rounded,
                color: AppColors.purple,
                size: 42,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
