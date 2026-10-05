import '../models/account_type.dart';
import '../models/client_registration_data.dart';
import '../services/auth_service.dart';
import '../../../models/user_model.dart';

/// Application-facing entry point for authentication.
///
/// Screens/controllers should use this repository instead of calling a remote
/// authentication SDK or [AuthService] directly.
class AuthRepository {
  const AuthRepository(this._service);

  final AuthService _service;

  Future<UserModel> signIn({
    required String identifier,
    required String password,
  }) =>
      _service.signIn(identifier: identifier, password: password);

  Future<void> registerClient(ClientRegistrationData data) =>
      _service.registerClient(data);

  Future<void> registerAccount({
    required AccountType accountType,
    required String identifier,
    required String password,
  }) =>
      _service.registerAccount(
        accountType: accountType,
        identifier: identifier,
        password: password,
      );

  Future<void> signOut() => _service.signOut();
}
