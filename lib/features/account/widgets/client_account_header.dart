import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';

class ClientAccountHeader extends StatelessWidget {
  const ClientAccountHeader({
    required this.onNotifications,
    required this.onMenu,
    super.key,
  });

  final VoidCallback onNotifications;
  final VoidCallback onMenu;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primarySoft,
                    AppColors.cyanSoft,
                    AppColors.purpleSoft,
                  ],
                ),
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(38),
                ),
              ),
            ),
          ),
          const Positioned(
            top: -42,
            left: -32,
            child: _DecorativeCircle(size: 142, color: Color(0x337447F5)),
          ),
          const Positioned(
            right: 56,
            bottom: -56,
            child: _DecorativeCircle(size: 132, color: Color(0x3313C8E8)),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(22, 18, 12, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Text(
                      AppStrings.accountTitle,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -0.7,
                      ),
                    ),
                  ),
                ),
                _HeaderAction(
                  icon: PhosphorIconsRegular.bell,
                  tooltip: AppStrings.notifications,
                  onTap: onNotifications,
                ),
                const SizedBox(width: 4),
                _HeaderAction(
                  icon: PhosphorIconsRegular.list,
                  tooltip: AppStrings.openMenu,
                  onTap: onMenu,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderAction extends StatelessWidget {
  const _HeaderAction({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: Colors.white.withValues(alpha: 0.88),
        foregroundColor: AppColors.textPrimary,
        side: const BorderSide(color: Colors.white),
        shadowColor: AppColors.shadow,
        elevation: 2,
      ),
      icon: Icon(icon, size: 25),
    );
  }
}

class _DecorativeCircle extends StatelessWidget {
  const _DecorativeCircle({
    required this.size,
    required this.color,
  });

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
