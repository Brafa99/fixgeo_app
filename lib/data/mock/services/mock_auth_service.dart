import '../../../features/auth/models/account_type.dart';
import '../../../features/auth/models/client_registration_data.dart';
import '../../../features/auth/services/auth_service.dart';
import '../../../models/user_model.dart';
import '../../../repositories/user_repository.dart';
import '../mock_credentials.dart';
import '../repositories/mock_user_repository.dart';

class MockAuthService implements AuthService {
  MockAuthService({UserRepository? userRepository})
      : _userRepository = userRepository ?? MockUserRepository();

  final UserRepository _userRepository;

  @override
  Future<UserModel> signIn({
    required String identifier,
    required String password,
  }) async {
    final normalizedIdentifier = identifier.trim().toLowerCase();
    final normalizedPhone = _onlyDigits(normalizedIdentifier);
    final users = await _userRepository.getUsers();

    UserModel? matchedUser;
    for (final user in users) {
      final matchesEmail = user.email.toLowerCase() == normalizedIdentifier;
      final matchesPhone = normalizedPhone.isNotEmpty &&
          _onlyDigits(user.phone) == normalizedPhone;
      if (matchesEmail || matchesPhone) {
        matchedUser = user;
        break;
      }
    }

    if (matchedUser == null ||
        mockPasswordsByUserId[matchedUser.id] != password) {
      throw const AuthException('Usuario o contraseña incorrectos.');
    }
    if (!matchedUser.isActive) {
      throw const AuthException('Esta cuenta se encuentra inactiva.');
    }

    return matchedUser;
  }

  @override
  Future<void> registerAccount({
    required AccountType accountType,
    required String identifier,
    required String password,
  }) async {}

  @override
  Future<void> registerClient(ClientRegistrationData data) async {}

  @override
  Future<void> signOut() async {}

  String _onlyDigits(String value) => value.replaceAll(RegExp(r'\D'), '');
}
