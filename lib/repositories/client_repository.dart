import '../models/client_model.dart';

abstract interface class ClientRepository {
  Future<List<ClientModel>> getClients();

  Future<ClientModel?> getClientById(String id);
}
