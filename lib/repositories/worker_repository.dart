import '../models/worker_model.dart';

abstract interface class WorkerRepository {
  Future<List<WorkerModel>> getWorkers();

  Future<WorkerModel?> getWorkerById(String id);

  Future<List<WorkerModel>> getWorkersByService(String serviceId);

  Future<List<WorkerModel>> getNearbyWorkers({
    required double latitude,
    required double longitude,
    required String serviceId,
    double radiusKm = 10,
  });
}
