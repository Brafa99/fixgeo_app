import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/enums/service_request_status.dart';
import '../../../core/theme/app_colors.dart';

class OrderStatusBadge extends StatelessWidget {
  const OrderStatusBadge({required this.status, super.key});

  final ServiceRequestStatus status;

  @override
  Widget build(BuildContext context) {
    final style = _statusBadgeStyle(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: BorderRadius.circular(AppSizes.radiusSm),
      ),
      child: Text(
        style.label,
        style: TextStyle(
          color: style.foreground,
          fontSize: 11,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.4,
        ),
      ),
    );
  }

  ({String label, Color foreground, Color background}) _statusBadgeStyle(
    ServiceRequestStatus status,
  ) {
    return switch (status) {
      ServiceRequestStatus.pending || ServiceRequestStatus.searching => (
          label: 'NUEVA',
          foreground: AppColors.pink,
          background: AppColors.pinkSoft,
        ),
      ServiceRequestStatus.accepted || ServiceRequestStatus.quoteAccepted => (
          label: 'ACEPTADA',
          foreground: AppColors.success,
          background: AppColors.successSoft,
        ),
      ServiceRequestStatus.quoted || ServiceRequestStatus.providerFound => (
          label: 'COTIZADA',
          foreground: AppColors.serviceBlueDark,
          background: AppColors.cyanSoft,
        ),
      ServiceRequestStatus.inProgress || ServiceRequestStatus.onTheWay => (
          label: 'EN CURSO',
          foreground: AppColors.primary,
          background: AppColors.primarySoft,
        ),
      ServiceRequestStatus.completed => (
          label: 'COMPLETADA',
          foreground: AppColors.success,
          background: AppColors.successSoft,
        ),
      ServiceRequestStatus.cancelled => (
          label: 'CANCELADA',
          foreground: AppColors.error,
          background: AppColors.pinkSoft,
        ),
    };
  }
}
