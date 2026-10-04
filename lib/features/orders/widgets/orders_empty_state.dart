import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/theme/app_colors.dart';

class OrdersEmptyState extends StatelessWidget {
  const OrdersEmptyState({required this.onHowItWorksTap, super.key});

  final VoidCallback onHowItWorksTap;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 390),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _OrdersIllustration()
              .animate()
              .fadeIn(duration: 340.ms, curve: Curves.easeOut)
              .scaleXY(
                begin: 0.94,
                end: 1,
                duration: 420.ms,
                curve: Curves.easeOutBack,
              ),
          const SizedBox(height: 24),
          const Text(
            'Sin pedidos por ahora',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 26,
              fontWeight: FontWeight.w900,
              height: 1.08,
              letterSpacing: -0.6,
            ),
          ).animate().fadeIn(delay: 100.ms, duration: 300.ms),
          const SizedBox(height: 12),
          const Text(
            'Una vez que solicites un servicio, vas a poder seguir todo el '
            'proceso desde esta pantalla. Simple, rápido y transparente.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 16,
              height: 1.4,
            ),
          ).animate().fadeIn(delay: 150.ms, duration: 320.ms),
          const SizedBox(height: 24),
          OutlinedButton(
            onPressed: onHowItWorksTap,
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.primary,
              minimumSize: const Size(220, 52),
              padding: const EdgeInsets.symmetric(horizontal: 18),
              side: const BorderSide(color: Color(0xFFB9D8FF)),
              shape: const StadiumBorder(),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(PhosphorIconsRegular.question, size: 21),
                SizedBox(width: 9),
                Text(
                  '¿Cómo funciona?',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 8),
                Icon(PhosphorIconsRegular.caretRight, size: 17),
              ],
            ),
          ).animate().fadeIn(delay: 210.ms, duration: 320.ms),
        ],
      ),
    );
  }
}

class _OrdersIllustration extends StatelessWidget {
  const _OrdersIllustration();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      height: 172,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: 150,
            height: 150,
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
            width: 98,
            height: 114,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(26),
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
              size: 54,
              color: AppColors.blue,
            ),
          ),
          Positioned(
            left: 12,
            top: 28,
            child: _FloatingIcon(
              color: AppColors.purple,
              backgroundColor: AppColors.purpleSoft,
              icon: PhosphorIconsRegular.package,
            ),
          ),
          Positioned(
            right: 9,
            top: 39,
            child: _FloatingIcon(
              color: AppColors.pink,
              backgroundColor: AppColors.pinkSoft,
              icon: PhosphorIconsRegular.clock,
            ),
          ),
          const Positioned(
            right: 28,
            bottom: 8,
            child: _FloatingIcon(
              color: AppColors.cyan,
              backgroundColor: AppColors.cyanSoft,
              icon: PhosphorIconsRegular.check,
              size: 42,
            ),
          ),
        ],
      ),
    );
  }
}

class _FloatingIcon extends StatelessWidget {
  const _FloatingIcon({
    required this.color,
    required this.backgroundColor,
    required this.icon,
    this.size = 48,
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
        border: Border.all(color: Colors.white, width: 3),
      ),
      child: Icon(icon, color: color, size: size * 0.46),
    );
  }
}
