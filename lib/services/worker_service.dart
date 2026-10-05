import '../models/worker_model.dart';
import '../repositories/worker_repository.dart';

class WorkerService {
  const WorkerService(this._repository);

  final WorkerRepository _repository;

  Future<List<WorkerModel>> getWorkers() => _repository.getWorkers();

  Future<WorkerModel?> getWorkerById(String id) =>
      _repository.getWorkerById(id);

  Future<List<WorkerModel>> getWorkersByService(String serviceId) =>
      _repository.getWorkersByService(serviceId);

  Future<List<WorkerModel>> getNearbyWorkers({
    required double latitude,
    required double longitude,
    required String serviceId,
    double radiusKm = 10,
  }) {
    return _repository.getNearbyWorkers(
      latitude: latitude,
      longitude: longitude,
      serviceId: serviceId,
      radiusKm: radiusKm,
    );
  }
}
