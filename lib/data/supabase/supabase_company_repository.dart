import '../../models/company_model.dart';
import '../../repositories/company_repository.dart';

class SupabaseCompanyRepository implements CompanyRepository {
  // TODO: Inject a Supabase client and map rows with CompanyModel.fromJson.

  @override
  Future<List<CompanyModel>> getCompanies() => throw UnimplementedError();

  @override
  Future<List<CompanyModel>> getCompaniesByService(String serviceId) =>
      throw UnimplementedError();

  @override
  Future<CompanyModel?> getCompanyById(String id) => throw UnimplementedError();

  @override
  Future<List<CompanyModel>> getNearbyCompanies({
    required double latitude,
    required double longitude,
    required String serviceId,
    double radiusKm = 10,
  }) =>
      throw UnimplementedError();
}
