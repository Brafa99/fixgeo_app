import '../models/client_model.dart';
import '../repositories/client_repository.dart';

class ClientService {
  const ClientService(this._repository);

  final ClientRepository _repository;

  Future<List<ClientModel>> getClients() => _repository.getClients();

  Future<ClientModel?> getClientById(String id) =>
      _repository.getClientById(id);
}
