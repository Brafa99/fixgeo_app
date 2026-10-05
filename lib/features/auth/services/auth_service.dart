import '../models/account_type.dart';
import '../models/client_registration_data.dart';
import '../../../models/user_model.dart';

/// Defines the authentication operations supplied by the remote provider.
///
/// A Supabase implementation will live beside this contract; UI code must not
/// depend on that implementation directly.
abstract interface class AuthService {
  Future<UserModel> signIn({
    required String identifier,
    required String password,
  });

  Future<void> registerClient(ClientRegistrationData data);

  Future<void> registerAccount({
    required AccountType accountType,
    required String identifier,
    required String password,
  });

  Future<void> signOut();
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
