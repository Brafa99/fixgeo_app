import '../models/company_model.dart';
import '../repositories/company_repository.dart';

class CompanyService {
  const CompanyService(this._repository);

  final CompanyRepository _repository;

  Future<List<CompanyModel>> getCompanies() => _repository.getCompanies();

  Future<CompanyModel?> getCompanyById(String id) =>
      _repository.getCompanyById(id);

  Future<List<CompanyModel>> getCompaniesByService(String serviceId) =>
      _repository.getCompaniesByService(serviceId);

  Future<List<CompanyModel>> getNearbyCompanies({
    required double latitude,
    required double longitude,
    required String serviceId,
    double radiusKm = 10,
  }) {
    return _repository.getNearbyCompanies(
      latitude: latitude,
      longitude: longitude,
      serviceId: serviceId,
      radiusKm: radiusKm,
    );
  }
}
