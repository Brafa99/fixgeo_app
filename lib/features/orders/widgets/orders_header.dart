import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_gradients.dart';
import 'orders_search_field.dart';

class OrdersHeader extends StatelessWidget {
  const OrdersHeader({
    required this.onEnter,
    required this.onMenu,
    required this.onSearchChanged,
    super.key,
  });

  final VoidCallback onEnter;
  final VoidCallback onMenu;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 222,
      padding: const EdgeInsets.fromLTRB(20, 14, 14, 28),
      decoration: const BoxDecoration(gradient: AppGradients.header),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Row(
                  children: [
                    Icon(
                      PhosphorIconsFill.mapPin,
                      color: Colors.white,
                      size: 29,
                    ),
                    SizedBox(width: 6),
                    Text(
                      AppStrings.appName,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                        height: 1,
                        letterSpacing: -0.9,
                      ),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: onEnter,
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  backgroundColor: Colors.white,
                  minimumSize: const Size(92, 48),
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  AppStrings.enter,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                ),
              ),
              const SizedBox(width: 6),
              IconButton(
                onPressed: onMenu,
                tooltip: 'Menú',
                color: Colors.white,
                iconSize: 30,
                icon: const Icon(PhosphorIconsRegular.list),
              ),
            ],
          ),
          const SizedBox(height: 24),
          OrdersSearchField(onChanged: onSearchChanged),
        ],
      ),
    ).animate().fadeIn(duration: 280.ms, curve: Curves.easeOut);
  }
}
