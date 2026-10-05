import 'package:flutter/material.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/utils/app_image_cache.dart';
import '../../../core/utils/order_formatters.dart';
import '../../../models/client_model.dart';
import '../../../models/service_model.dart';
import '../../../models/service_request_model.dart';
import '../../../shared/widgets/optimized_asset_image.dart';
import 'order_status_badge.dart';

class WorkerOrderCard extends StatelessWidget {
  const WorkerOrderCard({
    required this.request,
    required this.distanceKm,
    required this.onTap,
    this.service,
    this.client,
    super.key,
  });

  final ServiceRequestModel request;
  final ServiceModel? service;
  final ClientModel? client;
  final double distanceKm;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final serviceName = service?.name ?? 'Servicio';
    final clientName = client?.fullName ?? 'Cliente';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
        boxShadow: AppShadows.card,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top row: Service icon + Service name ... Status badge
                Row(
                  children: [
                    _buildServiceIcon(service),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        serviceName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    OrderStatusBadge(status: request.status),
                  ],
                ),
                const SizedBox(height: 12),

                // Client row: Avatar + Name ... CaretRight
                Row(
                  children: [
                    _buildClientAvatar(client),
                    const SizedBox(width: 9),
                    Expanded(
                      child: Text(
                        clientName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const Icon(
                      PhosphorIconsRegular.caretRight,
                      size: 18,
                      color: AppColors.textSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Description
                Text(
                  request.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 14),

                // Footer metadata: Distance, Age, Scheduled/Urgency
                Row(
                  children: [
                    // Distance
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          PhosphorIconsRegular.mapPin,
                          size: 15,
                          color: AppColors.serviceBlue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatDistance(distanceKm),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),

                    // Age (createdAt)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          PhosphorIconsRegular.clock,
                          size: 15,
                          color: AppColors.serviceBlue,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          formatTimeAgo(request.createdAt),
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 16),

                    // Urgency / Schedule
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            request.scheduledFor == null
                                ? PhosphorIconsFill.lightning
                                : PhosphorIconsRegular.calendarBlank,
                            size: 15,
                            color: request.scheduledFor == null
                                ? AppColors.pink
                                : AppColors.serviceBlue,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              formatRequestSchedule(request.scheduledFor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: request.scheduledFor == null
                                    ? AppColors.pink
                                    : AppColors.textSecondary,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceIcon(ServiceModel? service) {
    final iconPath = service?.icon;

    return Container(
      width: 44,
      height: 44,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.cyanSoft,
        borderRadius: BorderRadius.circular(12),
      ),
      child: iconPath != null && iconPath.isNotEmpty
          ? OptimizedAssetImage(
              assetName: iconPath,
              cacheWidth: AppImageDecodeSize.category,
              fit: BoxFit.contain,
            )
          : const Icon(
              Icons.home_repair_service_rounded,
              color: AppColors.primary,
              size: 24,
            ),
    );
  }

  Widget _buildClientAvatar(ClientModel? client) {
    final image = client?.profileImage;

    return Container(
      width: 28,
      height: 28,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.cyanSoft,
      ),
      child: _buildAvatarContent(image),
    );
  }

  Widget _buildAvatarContent(String? image) {
    if (image != null && image.startsWith('assets/')) {
      return Image.asset(image, fit: BoxFit.cover);
    }
    if (image != null &&
        image.startsWith('http') &&
        !image.contains('.example')) {
      return Image.network(
        image,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _fallbackAvatar(),
      );
    }
    return _fallbackAvatar();
  }

  Widget _fallbackAvatar() {
    return const OptimizedAssetImage(
      assetName: AppAssets.client,
      cacheWidth: AppImageDecodeSize.avatar,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
    );
  }
}
