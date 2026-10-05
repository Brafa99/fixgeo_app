import '../../models/worker_model.dart';
import '../../repositories/worker_repository.dart';

class SupabaseWorkerRepository implements WorkerRepository {
  // TODO: Inject a Supabase client and map rows with WorkerModel.fromJson.

  @override
  Future<WorkerModel?> getWorkerById(String id) => throw UnimplementedError();

  @override
  Future<List<WorkerModel>> getWorkers() => throw UnimplementedError();

  @override
  Future<List<WorkerModel>> getWorkersByService(String serviceId) =>
      throw UnimplementedError();

  @override
  Future<List<WorkerModel>> getNearbyWorkers({
    required double latitude,
    required double longitude,
    required String serviceId,
    double radiusKm = 10,
  }) =>
      throw UnimplementedError();
}
