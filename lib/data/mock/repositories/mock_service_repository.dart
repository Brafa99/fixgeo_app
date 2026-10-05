import '../../../models/service_model.dart';
import '../../../repositories/service_repository.dart';
import '../mock_services.dart';

class MockServiceRepository implements ServiceRepository {
  MockServiceRepository({List<ServiceModel>? services})
      : _services = List.unmodifiable(services ?? mockServices);

  final List<ServiceModel> _services;

  @override
  Future<ServiceModel?> getServiceById(String id) async {
    for (final service in _services) {
      if (service.id == id) return service;
    }
    return null;
  }

  @override
  Future<List<ServiceModel>> getServices() async {
    return List.unmodifiable(_services.where((service) => service.isActive));
  }
}
