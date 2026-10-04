import '../models/company_registration_data.dart';

abstract interface class CompanyRegistrationService {
  Future<String> createAuthUser(CompanyRegistrationData data);

  Future<String?> uploadCompanyLogo(String userId, String? logoPath);

  Future<String> createCompany(
    CompanyRegistrationData data, {
    required String userId,
    String? logoUrl,
  });

  Future<void> associateServices(String companyId, List<String> serviceIds);
}

/// Implementación local para desarrollo. Puede reemplazarse por una versión
/// Supabase sin modificar las pantallas ni el controlador.
class LocalCompanyRegistrationService implements CompanyRegistrationService {
  const LocalCompanyRegistrationService();

  @override
  Future<String> createAuthUser(CompanyRegistrationData data) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return 'local-company-user';
  }

  @override
  Future<String?> uploadCompanyLogo(String userId, String? logoPath) async {
    if (logoPath == null) return null;
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return logoPath;
  }

  @override
  Future<String> createCompany(
    CompanyRegistrationData data, {
    required String userId,
    String? logoUrl,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return 'local-company';
  }

  @override
  Future<void> associateServices(
    String companyId,
    List<String> serviceIds,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }
}
