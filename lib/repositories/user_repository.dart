import '../core/enums/user_role.dart';
import '../models/user_model.dart';

abstract interface class UserRepository {
  Future<List<UserModel>> getUsers();

  Future<UserModel?> getUserById(String id);

  Future<List<UserModel>> getUsersByRole(UserRole role);
}
