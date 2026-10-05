import '../models/company_model.dart';

abstract interface class CompanyRepository {
  Future<List<CompanyModel>> getCompanies();

  Future<CompanyModel?> getCompanyById(String id);

  Future<List<CompanyModel>> getCompaniesByService(String serviceId);

  Future<List<CompanyModel>> getNearbyCompanies({
    required double latitude,
    required double longitude,
    required String serviceId,
    double radiusKm = 10,
  });
}
