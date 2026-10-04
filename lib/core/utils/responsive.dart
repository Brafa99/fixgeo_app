import 'package:flutter/widgets.dart';

import '../constants/app_sizes.dart';

abstract final class Responsive {
  static bool isCompact(BuildContext context) =>
      MediaQuery.sizeOf(context).width < 600;

  static double horizontalPadding(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width < 600 ? AppSizes.spacingMd : AppSizes.spacingXl;
  }
}
