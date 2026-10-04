import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/app_image_cache.dart';
import '../../../shared/widgets/optimized_asset_image.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;
  Future<void>? _preloadFuture;
  bool _isOpeningOnboarding = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2500),
    );
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubic,
    );
    _controller.addStatusListener(_handleAnimationStatus);
    _controller.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_preloadFuture != null) return;

    _preloadFuture = AppImagePreloader.preloadInitial(context);
    unawaited(
      _preloadFuture!.then((_) {
        if (!mounted) return Future<void>.value();
        return AppImagePreloader.preloadRemaining(context);
      }),
    );
  }

  void _handleAnimationStatus(AnimationStatus status) async {
    if (status == AnimationStatus.completed && !_isOpeningOnboarding) {
      _isOpeningOnboarding = true;
      try {
        await (_preloadFuture ?? Future<void>.value()).timeout(
          const Duration(milliseconds: 500),
        );
      } on TimeoutException {
        // Do not keep the user waiting if a slow device is still decoding.
      }
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, RouteNames.onboarding);
    }
  }

  @override
  void dispose() {
    _controller
      ..removeStatusListener(_handleAnimationStatus)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFF2F8FF), Colors.white, Color(0xFFFCF7FF)],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final logoSize = math.min(constraints.maxWidth * 0.34, 156.0);
              final barWidth = math.min(constraints.maxWidth * 0.46, 170.0);

              return Stack(
                alignment: Alignment.center,
                children: [
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        OptimizedAssetImage(
                          assetName: AppAssets.logo,
                          cacheWidth: AppImageDecodeSize.logo,
                          width: logoSize,
                          height: logoSize,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: AppSizes.spacingMd),
                        const Text(
                          AppStrings.appName,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            height: 1,
                            letterSpacing: -1.2,
                          ),
                        ),
                        const SizedBox(height: AppSizes.spacingXs),
                        const Text(
                          AppStrings.tagline,
                          style: TextStyle(
                            color: AppColors.primary,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: constraints.maxHeight * 0.1,
                    child: _AnimatedGradientProgress(
                      animation: _progress,
                      width: barWidth,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class _AnimatedGradientProgress extends StatelessWidget {
  const _AnimatedGradientProgress({
    required this.animation,
    required this.width,
  });

  final Animation<double> animation;
  final double width;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Cargando FixGeo',
      child: Container(
        width: width,
        height: 6,
        decoration: BoxDecoration(
          color: AppColors.border,
          borderRadius: BorderRadius.circular(AppSizes.radiusSm),
        ),
        clipBehavior: Clip.antiAlias,
        alignment: Alignment.centerLeft,
        child: AnimatedBuilder(
          animation: animation,
          builder: (context, child) => FractionallySizedBox(
            widthFactor: animation.value,
            heightFactor: 1,
            child: child,
          ),
          child: const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: AppColors.splashGradient),
            ),
          ),
        ),
      ),
    );
  }
}
