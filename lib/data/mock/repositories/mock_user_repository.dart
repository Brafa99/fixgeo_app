import '../../../core/enums/user_role.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../mock_clients.dart';
import '../mock_companies.dart';
import '../mock_workers.dart';

class MockUserRepository implements UserRepository {
  MockUserRepository({List<UserModel>? users})
      : _users = List.unmodifiable(
          users ?? [...mockClients, ...mockWorkers, ...mockCompanies],
        );

  final List<UserModel> _users;

  @override
  Future<UserModel?> getUserById(String id) async {
    for (final user in _users) {
      if (user.id == id) return user;
    }
    return null;
  }

  @override
  Future<List<UserModel>> getUsers() async => List.unmodifiable(_users);

  @override
  Future<List<UserModel>> getUsersByRole(UserRole role) async {
    return List.unmodifiable(_users.where((user) => user.role == role));
  }
}
