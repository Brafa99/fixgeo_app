import 'package:flutter/material.dart';

import '../../../core/constants/app_sizes.dart';
import '../../../core/routes/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/utils/distance_calculator.dart';
import '../../../models/company_model.dart';
import '../../../models/service_request_model.dart';
import '../../../models/user_model.dart';
import '../../../models/worker_model.dart';

class NearbyProvidersScreen extends StatelessWidget {
  const NearbyProvidersScreen({
    required this.request,
    required this.serviceName,
    required this.workers,
    required this.companies,
    this.user,
    super.key,
  });

  final ServiceRequestModel request;
  final String serviceName;
  final List<WorkerModel> workers;
  final List<CompanyModel> companies;
  final UserModel? user;

  List<_NearbyProvider> get _providers {
    final providers = <_NearbyProvider>[
      ...workers.map(
        (worker) => _NearbyProvider.fromWorker(worker, request),
      ),
      ...companies.map(
        (company) => _NearbyProvider.fromCompany(company, request),
      ),
    ]..sort((first, second) => first.distanceKm.compareTo(second.distanceKm));
    return providers;
  }

  void _goHome(BuildContext context) {
    Navigator.of(context).pushNamedAndRemoveUntil(
      RouteNames.home,
      (route) => false,
      arguments: user,
    );
  }

  @override
  Widget build(BuildContext context) {
    final providers = _providers;
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        leading: const BackButton(),
        title: const Text(
          'Prestadores cercanos',
          style: TextStyle(fontWeight: FontWeight.w900),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: AppSizes.maxContentWidth,
            ),
            child: providers.isEmpty
                ? _EmptyProviders(onBackHome: () => _goHome(context))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(18, 20, 18, 30),
                    itemCount: providers.length + 1,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                serviceName,
                                style: const TextStyle(
                                  color: AppColors.textPrimary,
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                '${providers.length} opción(es) cerca de tu '
                                'ubicación',
                                style: const TextStyle(
                                  color: AppColors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      return _NearbyProviderTile(provider: providers[index - 1]);
                    },
                  ),
          ),
        ),
      ),
    );
  }
}

class _NearbyProvider {
  const _NearbyProvider({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.rating,
    required this.distanceKm,
  });

  factory _NearbyProvider.fromWorker(
    WorkerModel worker,
    ServiceRequestModel request,
  ) {
    return _NearbyProvider(
      id: worker.id,
      name: worker.fullName,
      type: 'Trabajador',
      location: worker.address,
      rating: worker.rating,
      distanceKm: calculateDistanceKm(
        request.latitude,
        request.longitude,
        worker.latitude,
        worker.longitude,
      ),
    );
  }

  factory _NearbyProvider.fromCompany(
    CompanyModel company,
    ServiceRequestModel request,
  ) {
    return _NearbyProvider(
      id: company.id,
      name: company.commercialName,
      type: 'Empresa',
      location: company.address,
      rating: company.rating,
      distanceKm: calculateDistanceKm(
        request.latitude,
        request.longitude,
        company.latitude,
        company.longitude,
      ),
    );
  }

  final String id;
  final String name;
  final String type;
  final String location;
  final double rating;
  final double distanceKm;
}

class _NearbyProviderTile extends StatelessWidget {
  const _NearbyProviderTile({required this.provider});

  final _NearbyProvider provider;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: ValueKey('nearby-provider-${provider.id}'),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primarySoft,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Icon(
              provider.type == 'Empresa'
                  ? Icons.business_rounded
                  : Icons.person_rounded,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.name,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '${provider.type} · ${provider.location}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(
                      Icons.star_rounded,
                      color: AppColors.warning,
                      size: 17,
                    ),
                    Text(
                      provider.rating.toStringAsFixed(1),
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.near_me_outlined,
                      color: AppColors.textSecondary,
                      size: 15,
                    ),
                    const SizedBox(width: 3),
                    Text(
                      '${provider.distanceKm.toStringAsFixed(1)} km',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyProviders extends StatelessWidget {
  const _EmptyProviders({required this.onBackHome});

  final VoidCallback onBackHome;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person_search_rounded,
              color: AppColors.textSecondary,
              size: 56,
            ),
            const SizedBox(height: 14),
            const Text(
              'No encontramos prestadores cercanos por ahora.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 17,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 18),
            OutlinedButton(
              onPressed: onBackHome,
              child: const Text('Volver al inicio'),
            ),
          ],
        ),
      ),
    );
  }
}
