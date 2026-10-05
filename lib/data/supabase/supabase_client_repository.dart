import '../../models/client_model.dart';
import '../../repositories/client_repository.dart';

class SupabaseClientRepository implements ClientRepository {
  // TODO: Inject a Supabase client and map rows with ClientModel.fromJson.

  @override
  Future<ClientModel?> getClientById(String id) => throw UnimplementedError();

  @override
  Future<List<ClientModel>> getClients() => throw UnimplementedError();
}
