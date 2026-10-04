import '../models/register_client_data.dart';

abstract interface class RegisterService {
  Future<void> registerClient(RegisterClientData data);
}

/// Temporary local implementation. Replace this class with the Supabase
/// implementation without changing the controller or presentation layer.
class LocalRegisterService implements RegisterService {
  const LocalRegisterService();

  @override
  Future<void> registerClient(RegisterClientData data) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
  }
}
