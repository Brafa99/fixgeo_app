import '../models/service_model.dart';
import '../repositories/service_repository.dart';

class ServiceService {
  const ServiceService(this._repository);

  final ServiceRepository _repository;

  Future<List<ServiceModel>> getServices() => _repository.getServices();

  Future<ServiceModel?> getServiceById(String id) =>
      _repository.getServiceById(id);
}
