import '../models/service_model.dart';

abstract interface class ServiceRepository {
  Future<List<ServiceModel>> getServices();

  Future<ServiceModel?> getServiceById(String id);
}
