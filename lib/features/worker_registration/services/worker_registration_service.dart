import '../models/worker_registration_data.dart';

abstract interface class WorkerRegistrationService {
  Future<String> createAuthUser(WorkerRegistrationData data);

  Future<String?> uploadProfileImage(String userId, String? imagePath);

  Future<String> createWorkerProfile(
    WorkerRegistrationData data, {
    required String userId,
    String? imageUrl,
  });

  Future<void> associateServices(String workerId, List<String> categoryIds);
}

/// Local development implementation. A Supabase implementation can replace
/// this service while the controller and UI remain unchanged.
class LocalWorkerRegistrationService implements WorkerRegistrationService {
  const LocalWorkerRegistrationService();

  @override
  Future<String> createAuthUser(WorkerRegistrationData data) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return 'local-user';
  }

  @override
  Future<String?> uploadProfileImage(String userId, String? imagePath) async {
    if (imagePath == null) return null;
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return imagePath;
  }

  @override
  Future<String> createWorkerProfile(
    WorkerRegistrationData data, {
    required String userId,
    String? imageUrl,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return 'local-worker';
  }

  @override
  Future<void> associateServices(
    String workerId,
    List<String> categoryIds,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
  }
}
