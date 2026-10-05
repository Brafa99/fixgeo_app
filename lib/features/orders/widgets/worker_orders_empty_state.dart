import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/theme/app_colors.dart';

class WorkerOrdersEmptyState extends StatelessWidget {
  const WorkerOrdersEmptyState({
    this.title = 'No hay pedidos nuevos',
    this.subtitle = 'Cuando aparezca un servicio cerca de ti lo verás aquí.',
    super.key,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const _WorkerOrdersIllustration()
                  .animate()
                  .fadeIn(duration: 320.ms, curve: Curves.easeOut)
                  .scaleXY(
                    begin: 0.94,
                    end: 1,
                    duration: 400.ms,
                    curve: Curves.easeOutBack,
                  ),
              const SizedBox(height: 22),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  height: 1.15,
                  letterSpacing: -0.5,
                ),
              ).animate().fadeIn(delay: 100.ms, duration: 280.ms),
              const SizedBox(height: 10),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14,
                  height: 1.45,
                ),
              ).animate().fadeIn(delay: 150.ms, duration: 300.ms),
            ],
          ),
        ),
      ),
    );
  }
}

class _WorkerOrdersIllustration extends StatelessWidget {
  const _WorkerOrdersIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 160,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFE8FAFD), Color(0xFFEDE9FF)],
              ),
            ),
          ),
          Container(
            width: 90,
            height: 104,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x14083B8C),
                  blurRadius: 18,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              PhosphorIconsRegular.clipboardText,
              size: 50,
              color: AppColors.primary,
            ),
          ),
          Positioned(
            left: 14,
            top: 24,
            child: _FloatingBadge(
              color: AppColors.primary,
              backgroundColor: AppColors.primarySoft,
              icon: PhosphorIconsRegular.wrench,
            ),
          ),
          Positioned(
            right: 12,
            top: 34,
            child: _FloatingBadge(
              color: AppColors.pink,
              backgroundColor: AppColors.pinkSoft,
              icon: PhosphorIconsRegular.clock,
            ),
          ),
          const Positioned(
            right: 24,
            bottom: 8,
            child: _FloatingBadge(
              color: AppColors.cyan,
              backgroundColor: AppColors.cyanSoft,
              icon: PhosphorIconsRegular.mapPin,
              size: 40,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingBadge extends StatelessWidget {
  const _FloatingBadge({
    required this.color,
    required this.backgroundColor,
    required this.icon,
    this.size = 44,
  });

  final Color color;
  final Color backgroundColor;
  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2.5),
      ),
      child: Icon(icon, color: color, size: size * 0.46),
    );
  }
}
