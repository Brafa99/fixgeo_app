import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppShadows {
  static const card = <BoxShadow>[
    BoxShadow(
      color: AppColors.shadow,
      blurRadius: 16,
      offset: Offset(0, 6),
    ),
  ];
}
