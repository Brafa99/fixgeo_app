import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';

class WorkerAvailabilityControl extends StatelessWidget {
  const WorkerAvailabilityControl({
    required this.isAvailable,
    required this.onChanged,
    super.key,
  });

  final bool isAvailable;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isAvailable ? AppColors.success : AppColors.warning,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  isAvailable ? 'Disponible' : 'No disponible',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Semantics(
                label: 'Cambiar disponibilidad',
                toggled: isAvailable,
                child: Switch(
                  value: isAvailable,
                  onChanged: onChanged,
                  activeThumbColor: AppColors.primary,
                  activeTrackColor: AppColors.primarySoft,
                ),
              ),
            ],
          ),
          if (!isAvailable) ...[
            const SizedBox(height: 8),
            const Row(
              children: [
                Icon(
                  PhosphorIconsRegular.info,
                  size: 15,
                  color: AppColors.warning,
                ),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'No disponible para nuevos pedidos',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
