import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/theme/app_colors.dart';
import '../models/request_preview.dart';

class RequestCard extends StatelessWidget {
  const RequestCard({required this.request, this.onTap, super.key});

  final RequestPreview request;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final statusStyle = _statusStyle(request.status);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(18),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(AppSizes.spacingMd),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: BorderRadius.circular(18),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: const BoxDecoration(
                  color: AppColors.primarySoft,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.home_repair_service_outlined,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      request.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      request.date,
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSizes.spacingSm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: statusStyle.background,
                  borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                ),
                child: Text(
                  statusStyle.label,
                  style: TextStyle(
                    color: statusStyle.foreground,
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ({String label, Color foreground, Color background}) _statusStyle(
    RequestStatus status,
  ) {
    return switch (status) {
      RequestStatus.pending => (
          label: 'Pendiente',
          foreground: AppColors.warning,
          background: AppColors.warningSoft,
        ),
      RequestStatus.inProgress => (
          label: 'En proceso',
          foreground: AppColors.blue,
          background: AppColors.primarySoft,
        ),
      RequestStatus.completed => (
          label: 'Completado',
          foreground: AppColors.success,
          background: AppColors.successSoft,
        ),
    };
  }
}
