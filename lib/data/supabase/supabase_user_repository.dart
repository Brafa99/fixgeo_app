import '../../core/enums/user_role.dart';
import '../../models/user_model.dart';
import '../../repositories/user_repository.dart';

class SupabaseUserRepository implements UserRepository {
  // TODO: Inject a Supabase client and map rows with UserModel.fromJson.

  @override
  Future<UserModel?> getUserById(String id) => throw UnimplementedError();

  @override
  Future<List<UserModel>> getUsers() => throw UnimplementedError();

  @override
  Future<List<UserModel>> getUsersByRole(UserRole role) =>
      throw UnimplementedError();
}
