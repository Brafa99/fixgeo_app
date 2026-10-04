import 'package:flutter/material.dart';

import '../../core/utils/app_image_cache.dart';

class OptimizedAssetImage extends StatelessWidget {
  const OptimizedAssetImage({
    required this.assetName,
    required this.cacheWidth,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.alignment = Alignment.center,
    super.key,
  });

  final String assetName;
  final int cacheWidth;
  final double? width;
  final double? height;
  final BoxFit fit;
  final AlignmentGeometry alignment;

  @override
  Widget build(BuildContext context) {
    return Image(
      image: optimizedAssetProvider(assetName, cacheWidth: cacheWidth),
      width: width,
      height: height,
      fit: fit,
      alignment: alignment,
      filterQuality: FilterQuality.low,
      gaplessPlayback: true,
    );
  }
}
