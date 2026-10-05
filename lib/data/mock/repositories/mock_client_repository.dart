import '../../../models/client_model.dart';
import '../../../repositories/client_repository.dart';
import '../mock_clients.dart';

class MockClientRepository implements ClientRepository {
  MockClientRepository({List<ClientModel>? clients})
      : _clients = List.unmodifiable(clients ?? mockClients);

  final List<ClientModel> _clients;

  @override
  Future<ClientModel?> getClientById(String id) async {
    for (final client in _clients) {
      if (client.id == id) return client;
    }
    return null;
  }

  @override
  Future<List<ClientModel>> getClients() async => List.unmodifiable(_clients);
}
