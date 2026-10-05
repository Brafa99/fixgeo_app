import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';

class MockLocationMap extends StatelessWidget {
  const MockLocationMap({
    required this.neighborhood,
    required this.onLocate,
    super.key,
  });

  final String neighborhood;
  final VoidCallback onLocate;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 205,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4FA),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Stack(
        children: [
          const Positioned.fill(child: CustomPaint(painter: _MapPainter())),
          Positioned(
            top: 24,
            left: 70,
            child: Transform.rotate(
              angle: -0.35,
              child: const Text(
                'Av. Principal',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 54,
            left: 56,
            child: Text(
              neighborhood,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const Align(
            alignment: Alignment(0.05, -0.08),
            child: Icon(
              Icons.location_on_rounded,
              color: AppColors.pink,
              size: 45,
            ),
          ),
          const Align(
            alignment: Alignment(0.62, 0.42),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.blue,
                shape: BoxShape.circle,
                border: Border.fromBorderSide(
                  BorderSide(color: AppColors.surface, width: 3),
                ),
              ),
              child: SizedBox.square(dimension: 17),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 12,
            child: IconButton.filled(
              onPressed: onLocate,
              tooltip: 'Usar mi ubicación',
              style: IconButton.styleFrom(
                backgroundColor: AppColors.surface,
                foregroundColor: AppColors.primary,
                shadowColor: AppColors.shadow,
                elevation: 3,
              ),
              icon: const Icon(Icons.my_location_rounded),
            ),
          ),
        ],
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  const _MapPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final minorRoad = Paint()
      ..color = Colors.white
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke;
    final majorRoad = Paint()
      ..color = const Color(0xFFD9E4F2)
      ..strokeWidth = 11
      ..style = PaintingStyle.stroke;

    for (var x = -40.0; x < size.width + 80; x += 58) {
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + 100, size.height),
        minorRoad,
      );
    }
    for (var y = 20.0; y < size.height; y += 52) {
      canvas.drawLine(
        Offset(0, y),
        Offset(size.width, y - 30),
        minorRoad,
      );
    }
    canvas.drawLine(
      Offset(-10, size.height - 15),
      Offset(size.width + 10, 45),
      majorRoad,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
