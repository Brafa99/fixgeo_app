import '../core/enums/provider_type.dart';
import '../core/enums/service_request_status.dart';
import '../core/utils/distance_calculator.dart';
import '../models/service_request_model.dart';
import '../models/worker_model.dart';
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

  Future<List<ServiceRequestModel>> getRequestsForWorker({
    required WorkerModel worker,
    bool? isAvailableOverride,
  }) async {
    final allRequests = await _repository.getRequests();
    final isAvailable = isAvailableOverride ?? worker.isAvailable;

    return allRequests.where((request) {
      final isAssignedToThisWorker = request.selectedProviderId == worker.id &&
          request.selectedProviderType == ProviderType.worker;

      // Always include requests assigned to this worker (accepted, quoted, etc.)
      if (isAssignedToThisWorker) {
        return true;
      }

      // If worker is not available, they cannot receive new requests
      if (!isAvailable) {
        return false;
      }

      // If assigned to another provider, it cannot appear as new for this worker
      if (request.selectedProviderId != null &&
          request.selectedProviderId != worker.id) {
        return false;
      }

      // Only pending requests appear as new requests
      if (request.status != ServiceRequestStatus.pending) {
        return false;
      }

      // Service compatibility: worker must offer this service
      if (!worker.serviceIds.contains(request.serviceId)) {
        return false;
      }

      // Radius check: must be within worker's coverage radius
      final distanceKm = calculateDistanceKm(
        worker.latitude,
        worker.longitude,
        request.latitude,
        request.longitude,
      );
      if (distanceKm > worker.coverageRadiusKm) {
        return false;
      }

      return true;
    }).toList()
      ..sort((a, b) {
        final dateComparison = b.createdAt.compareTo(a.createdAt);
        if (dateComparison != 0) return dateComparison;
        final distA = calculateDistanceKm(
          worker.latitude,
          worker.longitude,
          a.latitude,
          a.longitude,
        );
        final distB = calculateDistanceKm(
          worker.latitude,
          worker.longitude,
          b.latitude,
          b.longitude,
        );
        return distA.compareTo(distB);
      });
  }

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

