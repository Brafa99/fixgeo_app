import '../../../core/enums/provider_type.dart';
import '../../../models/company_model.dart';
import '../../../models/worker_model.dart';

class ProviderDetailData {
  const ProviderDetailData({
    required this.id,
    required this.type,
    required this.name,
    required this.profileImage,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.rating,
    required this.reviewCount,
    required this.isAvailable,
    required this.serviceIds,
    this.experienceYears,
    this.coverageRadiusKm,
  });

  factory ProviderDetailData.fromWorker(WorkerModel worker) {
    return ProviderDetailData(
      id: worker.id,
      type: ProviderType.worker,
      name: worker.fullName,
      profileImage: worker.profileImage,
      description: worker.description,
      address: worker.address,
      latitude: worker.latitude,
      longitude: worker.longitude,
      rating: worker.rating,
      reviewCount: worker.reviewCount,
      isAvailable: worker.isActive && worker.isAvailable,
      serviceIds: List.unmodifiable(worker.serviceIds),
      experienceYears: worker.experience,
      coverageRadiusKm: worker.coverageRadiusKm,
    );
  }

  factory ProviderDetailData.fromCompany(CompanyModel company) {
    return ProviderDetailData(
      id: company.id,
      type: ProviderType.company,
      name: company.commercialName,
      profileImage: company.logo,
      description: company.description,
      address: company.address,
      latitude: company.latitude,
      longitude: company.longitude,
      rating: company.rating,
      reviewCount: company.reviewCount,
      isAvailable: company.isActive,
      serviceIds: List.unmodifiable(company.serviceIds),
    );
  }

  final String id;
  final ProviderType type;
  final String name;
  final String profileImage;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final double rating;
  final int reviewCount;
  final bool isAvailable;
  final List<String> serviceIds;
  final int? experienceYears;
  final double? coverageRadiusKm;

  String get typeLabel => type == ProviderType.worker ? 'Profesional' : 'Empresa';

  String get initials {
    final parts = name
        .trim()
        .split(RegExp(r'\s+'))
        .where((part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return '?';
    final first = parts.first[0];
    final last = parts.length > 1 ? parts.last[0] : '';
    return '$first$last'.toUpperCase();
  }
}
