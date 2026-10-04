import 'package:flutter/widgets.dart';

import '../constants/app_assets.dart';

abstract final class AppImageDecodeSize {
  static const int logo = 384;
  static const int illustration = 640;
  static const int decorative = 320;
  static const int avatar = 256;
  static const int category = 224;
  static const int social = 320;
}

ImageProvider<Object> optimizedAssetProvider(
  String assetName, {
  required int cacheWidth,
}) {
  return ResizeImage.resizeIfNeeded(
    cacheWidth,
    null,
    AssetImage(assetName),
  );
}

abstract final class AppImagePreloader {
  static const _initialAssets = <({String path, int cacheWidth})>[
    (path: AppAssets.logo, cacheWidth: AppImageDecodeSize.logo),
    (
      path: AppAssets.onboardingStart,
      cacheWidth: AppImageDecodeSize.illustration,
    ),
  ];

  static const _remainingAssets = <({String path, int cacheWidth})>[
    (path: AppAssets.paintBrush, cacheWidth: AppImageDecodeSize.decorative),
    (path: AppAssets.megaphone, cacheWidth: AppImageDecodeSize.decorative),
    (path: AppAssets.workers, cacheWidth: AppImageDecodeSize.illustration),
    (path: AppAssets.worker, cacheWidth: AppImageDecodeSize.illustration),
    (
      path: AppAssets.servicesPhone,
      cacheWidth: AppImageDecodeSize.illustration,
    ),
    (path: AppAssets.client, cacheWidth: AppImageDecodeSize.avatar),
    (path: AppAssets.provider, cacheWidth: AppImageDecodeSize.avatar),
    (path: AppAssets.company, cacheWidth: AppImageDecodeSize.avatar),
    (
      path: AppAssets.categoryPlumbing,
      cacheWidth: AppImageDecodeSize.category,
    ),
    (
      path: AppAssets.categoryElectricity,
      cacheWidth: AppImageDecodeSize.category,
    ),
    (
      path: AppAssets.categoryPainting,
      cacheWidth: AppImageDecodeSize.category,
    ),
    (
      path: AppAssets.categoryCleaning,
      cacheWidth: AppImageDecodeSize.category,
    ),
    (
      path: AppAssets.categoryGardening,
      cacheWidth: AppImageDecodeSize.category,
    ),
    (
      path: AppAssets.categoryMoving,
      cacheWidth: AppImageDecodeSize.category,
    ),
    (
      path: AppAssets.categoryMasonry,
      cacheWidth: AppImageDecodeSize.category,
    ),
    (
      path: AppAssets.categoryMore,
      cacheWidth: AppImageDecodeSize.category,
    ),
    (path: AppAssets.socialWhatsapp, cacheWidth: AppImageDecodeSize.social),
    (path: AppAssets.socialInstagram, cacheWidth: AppImageDecodeSize.social),
    (path: AppAssets.socialYoutube, cacheWidth: AppImageDecodeSize.social),
  ];

  static Future<void> preloadInitial(BuildContext context) =>
      _preloadAssets(context, _initialAssets);

  static Future<void> preloadRemaining(BuildContext context) =>
      _preloadAssets(context, _remainingAssets);

  static Future<void> _preloadAssets(
    BuildContext context,
    List<({String path, int cacheWidth})> assets,
  ) async {
    const batchSize = 3;
    for (var start = 0; start < assets.length; start += batchSize) {
      final end = (start + batchSize).clamp(0, assets.length);
      await Future.wait(
        assets.sublist(start, end).map(
              (asset) => _precache(
                context,
                path: asset.path,
                cacheWidth: asset.cacheWidth,
              ),
            ),
      );
      await Future<void>.delayed(Duration.zero);
    }
  }

  static Future<void> _precache(
    BuildContext context, {
    required String path,
    required int cacheWidth,
  }) async {
    try {
      await precacheImage(
        optimizedAssetProvider(path, cacheWidth: cacheWidth),
        context,
      );
    } on Object {
      // Image.asset still handles the normal error path if preloading fails.
    }
  }
}
