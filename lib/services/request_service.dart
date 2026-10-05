import '../models/service_request_model.dart';
import '../core/enums/provider_type.dart';
import '../core/enums/service_request_status.dart';
import '../repositories/service_request_repository.dart';

class RequestService {
  const RequestService(this._repository);

  final ServiceRequestRepository _repository;

  Future<List<ServiceRequestModel>> getRequests() => _repository.getRequests();

  Future<ServiceRequestModel?> getRequestById(String id) =>
      _repository.getRequestById(id);

  Future<List<ServiceRequestModel>> getRequestsByClient(String clientId) =>
      _repository.getRequestsByClient(clientId);

  Future<ServiceRequestModel> createRequest(ServiceRequestModel request) =>
      _repository.createRequest(request);

  Future<ServiceRequestModel> updateRequest(ServiceRequestModel request) =>
      _repository.updateRequest(request);

  Future<ServiceRequestModel> selectProvider({
    required String requestId,
    required String providerId,
    required ProviderType providerType,
    DateTime? updatedAt,
  }) async {
    final request = await _repository.getRequestById(requestId);
    if (request == null) {
      throw StateError('Request $requestId does not exist.');
    }
    return _repository.updateRequest(
      request.copyWith(
        selectedProviderId: providerId,
        selectedProviderType: providerType,
        status: ServiceRequestStatus.providerFound,
        updatedAt: (updatedAt ?? DateTime.now()).toUtc(),
      ),
    );
  }
}
