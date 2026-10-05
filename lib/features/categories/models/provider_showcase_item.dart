import '../../../core/constants/app_assets.dart';
import '../../../models/company_model.dart';
import '../../../models/worker_model.dart';

class ProviderShowcaseItem {
  const ProviderShowcaseItem({
    required this.id,
    required this.name,
    required this.typeLabel,
    required this.details,
    required this.location,
    required this.rating,
    required this.profileImage,
    required this.fallbackAsset,
  });

  factory ProviderShowcaseItem.fromWorker(
    WorkerModel worker,
    Map<String, String> serviceNames,
  ) {
    return ProviderShowcaseItem(
      id: worker.id,
      name: worker.fullName,
      typeLabel: 'Trabajador',
      details: _serviceSummary(worker.serviceIds, serviceNames),
      location: worker.address,
      rating: worker.rating,
      profileImage: worker.profileImage,
      fallbackAsset: AppAssets.provider,
    );
  }

  factory ProviderShowcaseItem.fromCompany(
    CompanyModel company,
    Map<String, String> serviceNames,
  ) {
    return ProviderShowcaseItem(
      id: company.id,
      name: company.commercialName,
      typeLabel: 'Empresa',
      details: _serviceSummary(company.serviceIds, serviceNames),
      location: company.address,
      rating: company.rating,
      profileImage: company.logo,
      fallbackAsset: AppAssets.company,
    );
  }

  final String id;
  final String name;
  final String typeLabel;
  final String details;
  final String location;
  final double rating;
  final String profileImage;
  final String fallbackAsset;

  static String _serviceSummary(
    List<String> serviceIds,
    Map<String, String> serviceNames,
  ) {
    return serviceIds
        .map((id) => serviceNames[id])
        .whereType<String>()
        .join(' · ');
  }
}
