import '../models/service_request_model.dart';

abstract interface class ServiceRequestRepository {
  Future<List<ServiceRequestModel>> getRequests();

  Future<ServiceRequestModel?> getRequestById(String id);

  Future<List<ServiceRequestModel>> getRequestsByClient(String clientId);

  Future<ServiceRequestModel> createRequest(ServiceRequestModel request);

  Future<ServiceRequestModel> updateRequest(ServiceRequestModel request);
}
