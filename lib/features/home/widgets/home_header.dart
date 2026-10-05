import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';

class HomeHeader extends StatelessWidget {
  const HomeHeader({
    required this.onEnter,
    required this.onMenu,
    this.userName,
    super.key,
  });

  final VoidCallback onEnter;
  final VoidCallback onMenu;
  final String? userName;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 174,
      padding: const EdgeInsets.fromLTRB(22, 16, 14, 54),
      decoration: const BoxDecoration(
        gradient: AppGradients.header,
      ),
      child: Row(
        children: [
          const Expanded(
            child: Row(
              children: [
                Icon(
                  Icons.location_on_rounded,
                  color: Colors.white,
                  size: 30,
                ),
                SizedBox(width: 5),
                Flexible(
                  child: Text(
                    AppStrings.appName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      height: 1,
                      letterSpacing: -1,
                    ),
                  ),
                ),
              ],
            ),
          ),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 154),
            child: TextButton(
              onPressed: onEnter,
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textPrimary,
                backgroundColor: Colors.white,
                minimumSize: const Size(88, 46),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                shape: const StadiumBorder(),
              ),
              child: Text(
                userName == null ? AppStrings.enter : 'Hola, $userName',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSizes.spacingSm),
          IconButton(
            onPressed: onMenu,
            tooltip: 'Menú',
            color: Colors.white,
            iconSize: 34,
            icon: const Icon(Icons.menu_rounded),
          ),
        ],
      ),
    );
  }
}
