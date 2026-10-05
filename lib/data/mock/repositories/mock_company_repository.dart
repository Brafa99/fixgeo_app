import '../../../core/utils/distance_calculator.dart';
import '../../../models/company_model.dart';
import '../../../repositories/company_repository.dart';
import '../mock_companies.dart';

class MockCompanyRepository implements CompanyRepository {
  MockCompanyRepository({List<CompanyModel>? companies})
      : _companies = List.unmodifiable(companies ?? mockCompanies);

  final List<CompanyModel> _companies;

  @override
  Future<List<CompanyModel>> getCompanies() async =>
      List.unmodifiable(_companies);

  @override
  Future<List<CompanyModel>> getCompaniesByService(String serviceId) async {
    return List.unmodifiable(
      _companies.where(
        (company) => company.isActive && company.serviceIds.contains(serviceId),
      ),
    );
  }

  @override
  Future<CompanyModel?> getCompanyById(String id) async {
    for (final company in _companies) {
      if (company.id == id) return company;
    }
    return null;
  }

  @override
  Future<List<CompanyModel>> getNearbyCompanies({
    required double latitude,
    required double longitude,
    required String serviceId,
    double radiusKm = 10,
  }) async {
    if (radiusKm <= 0) return const [];

    final matches = <({CompanyModel company, double distance})>[];
    for (final company in _companies) {
      if (!company.isActive || !company.serviceIds.contains(serviceId)) {
        continue;
      }

      final distance = calculateDistanceKm(
        latitude,
        longitude,
        company.latitude,
        company.longitude,
      );
      if (distance <= radiusKm) {
        matches.add((company: company, distance: distance));
      }
    }

    matches.sort((first, second) => first.distance.compareTo(second.distance));
    return List.unmodifiable(matches.map((match) => match.company));
  }
}
