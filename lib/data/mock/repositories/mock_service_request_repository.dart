import '../../../models/service_request_model.dart';
import '../../../repositories/service_request_repository.dart';
import '../mock_requests.dart';

class MockServiceRequestRepository implements ServiceRequestRepository {
  MockServiceRequestRepository({List<ServiceRequestModel>? requests})
      : _requests = List.of(requests ?? mockRequests);

  final List<ServiceRequestModel> _requests;

  @override
  Future<ServiceRequestModel> createRequest(
    ServiceRequestModel request,
  ) async {
    if (_requests.any((current) => current.id == request.id)) {
      throw StateError('A request with id ${request.id} already exists.');
    }
    _requests.add(request);
    return request;
  }

  @override
  Future<ServiceRequestModel?> getRequestById(String id) async {
    for (final request in _requests) {
      if (request.id == id) return request;
    }
    return null;
  }

  @override
  Future<List<ServiceRequestModel>> getRequests() async {
    return List.unmodifiable(_requests);
  }

  @override
  Future<List<ServiceRequestModel>> getRequestsByClient(String clientId) async {
    return List.unmodifiable(
      _requests.where((request) => request.clientId == clientId),
    );
  }

  @override
  Future<ServiceRequestModel> updateRequest(
    ServiceRequestModel request,
  ) async {
    final index = _requests.indexWhere((current) => current.id == request.id);
    if (index == -1) {
      throw StateError('Request ${request.id} does not exist.');
    }
    _requests[index] = request;
    return request;
  }
}
