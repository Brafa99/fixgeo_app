import '../../models/service_request_model.dart';
import '../../repositories/service_request_repository.dart';

class SupabaseServiceRequestRepository implements ServiceRequestRepository {
  // TODO: Inject a Supabase client and persist request.toJson() rows.

  @override
  Future<ServiceRequestModel> createRequest(ServiceRequestModel request) =>
      throw UnimplementedError();

  @override
  Future<ServiceRequestModel?> getRequestById(String id) =>
      throw UnimplementedError();

  @override
  Future<List<ServiceRequestModel>> getRequests() => throw UnimplementedError();

  @override
  Future<List<ServiceRequestModel>> getRequestsByClient(String clientId) =>
      throw UnimplementedError();

  @override
  Future<ServiceRequestModel> updateRequest(ServiceRequestModel request) =>
      throw UnimplementedError();
}
