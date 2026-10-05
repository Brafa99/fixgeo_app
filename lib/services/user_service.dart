import '../core/enums/user_role.dart';
import '../models/user_model.dart';
import '../repositories/user_repository.dart';

class UserService {
  const UserService(this._repository);

  final UserRepository _repository;

  Future<List<UserModel>> getUsers() => _repository.getUsers();

  Future<UserModel?> getUserById(String id) => _repository.getUserById(id);

  Future<List<UserModel>> getUsersByRole(UserRole role) =>
      _repository.getUsersByRole(role);
}
