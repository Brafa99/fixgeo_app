import '../../models/service_model.dart';
import '../../repositories/service_repository.dart';

class SupabaseServiceRepository implements ServiceRepository {
  // TODO: Inject a Supabase client and map rows with ServiceModel.fromJson.

  @override
  Future<ServiceModel?> getServiceById(String id) => throw UnimplementedError();

  @override
  Future<List<ServiceModel>> getServices() => throw UnimplementedError();
}
