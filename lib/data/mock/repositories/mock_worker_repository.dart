import '../../../core/utils/distance_calculator.dart';
import '../../../models/worker_model.dart';
import '../../../repositories/worker_repository.dart';
import '../mock_workers.dart';

class MockWorkerRepository implements WorkerRepository {
  MockWorkerRepository({List<WorkerModel>? workers})
      : _workers = List.unmodifiable(workers ?? mockWorkers);

  final List<WorkerModel> _workers;

  @override
  Future<WorkerModel?> getWorkerById(String id) async {
    for (final worker in _workers) {
      if (worker.id == id) return worker;
    }
    return null;
  }

  @override
  Future<List<WorkerModel>> getWorkers() async => List.unmodifiable(_workers);

  @override
  Future<List<WorkerModel>> getWorkersByService(String serviceId) async {
    return List.unmodifiable(
      _workers.where(
        (worker) => worker.isActive && worker.serviceIds.contains(serviceId),
      ),
    );
  }

  @override
  Future<List<WorkerModel>> getNearbyWorkers({
    required double latitude,
    required double longitude,
    required String serviceId,
    double radiusKm = 10,
  }) async {
    if (radiusKm <= 0) return const [];

    final matches = <({double distance, WorkerModel worker})>[];
    for (final worker in _workers) {
      if (!worker.isActive ||
          !worker.isAvailable ||
          !worker.serviceIds.contains(serviceId)) {
        continue;
      }

      final distance = calculateDistanceKm(
        latitude,
        longitude,
        worker.latitude,
        worker.longitude,
      );
      if (distance <= radiusKm && distance <= worker.coverageRadiusKm) {
        matches.add((distance: distance, worker: worker));
      }
    }

    matches.sort((first, second) => first.distance.compareTo(second.distance));
    return List.unmodifiable(matches.map((match) => match.worker));
  }
}
