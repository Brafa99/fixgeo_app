import 'package:fixgeo_app/core/enums/service_request_status.dart';
import 'package:fixgeo_app/data/mock/mock_clients.dart';
import 'package:fixgeo_app/data/mock/mock_services.dart';
import 'package:fixgeo_app/data/mock/repositories/mock_client_repository.dart';
import 'package:fixgeo_app/data/mock/repositories/mock_service_repository.dart';
import 'package:fixgeo_app/features/service_request/controllers/create_service_request_controller.dart';
import 'package:fixgeo_app/features/service_request/services/service_request_image_picker.dart';
import 'package:fixgeo_app/models/service_request_model.dart';
import 'package:fixgeo_app/repositories/service_request_repository.dart';
import 'package:fixgeo_app/services/client_service.dart';
import 'package:fixgeo_app/services/request_service.dart';
import 'package:fixgeo_app/services/service_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final now = DateTime.utc(2026, 10, 4, 14, 30);

  test('loads the service and mock location from the logged client', () async {
    final controller = _buildController(now: now);
    addTearDown(controller.dispose);

    await controller.initialize();

    expect(controller.service?.id, 'service_plumbing');
    expect(controller.address, mockClients.first.address);
    expect(controller.latitude, mockClients.first.latitude);
    expect(controller.longitude, mockClients.first.longitude);
    expect(controller.dateSummary, 'Lo antes posible');
  });

  test('creates and persists a pending request through RequestService', () async {
    final repository = _RecordingRequestRepository();
    final controller = _buildController(
      now: now,
      requestRepository: repository,
    );
    addTearDown(controller.dispose);
    await controller.initialize();

    controller.updateDescription(
      'Tengo una fuga debajo del lavamanos y necesito una revisión.',
    );
    await controller.addImages(ServiceRequestImageSource.gallery);
    final request = await controller.submit();

    expect(request, isNotNull);
    expect(repository.created, same(request));
    expect(request?.clientId, mockClients.first.id);
    expect(request?.serviceId, 'service_plumbing');
    expect(request?.status, ServiceRequestStatus.pending);
    expect(request?.address, mockClients.first.address);
    expect(request?.images, ['/tmp/foto-1.jpg', '/tmp/foto-2.jpg']);
    expect(request?.scheduledFor, isNull);
    expect(request?.createdAt, now);
    expect(request?.updatedAt, now);
  });

  test('requires a valid description and date when date mode is selected',
      () async {
    final controller = _buildController(now: now);
    addTearDown(controller.dispose);
    await controller.initialize();

    controller.updateDescription('corto');
    expect(controller.canContinue, isFalse);
    expect(controller.validateDescription('corto'), isNotNull);

    controller.updateDescription('Reparar una pérdida de agua en la cocina.');
    controller.setScheduleOption(ServiceScheduleOption.chooseDate);
    expect(controller.canContinue, isFalse);

    controller.setScheduledDate(DateTime(2026, 10, 8));
    expect(controller.canContinue, isTrue);
    expect(controller.dateSummary, '08/10/2026');
  });

  test('editing after confirmation updates the same persisted request',
      () async {
    final repository = _RecordingRequestRepository();
    final controller = _buildController(
      now: now,
      requestRepository: repository,
    );
    addTearDown(controller.dispose);
    await controller.initialize();

    controller.updateDescription('Primera descripción válida del trabajo.');
    final firstRequest = await controller.submit();
    controller.updateDescription('Descripción editada manteniendo la solicitud.');
    final editedRequest = await controller.submit();

    expect(editedRequest?.id, firstRequest?.id);
    expect(repository.updated, same(editedRequest));
    expect(editedRequest?.description, contains('editada'));
  });
}

CreateServiceRequestController _buildController({
  required DateTime now,
  ServiceRequestRepository? requestRepository,
}) {
  return CreateServiceRequestController(
    serviceId: 'service_plumbing',
    user: mockClients.first,
    serviceService: ServiceService(
      MockServiceRepository(services: mockServices),
    ),
    clientService: ClientService(
      MockClientRepository(clients: mockClients),
    ),
    requestService: RequestService(
      requestRepository ?? _RecordingRequestRepository(),
    ),
    imagePicker: const _FakeImagePicker(),
    clock: () => now,
  );
}

class _FakeImagePicker implements ServiceRequestImagePicker {
  const _FakeImagePicker();

  @override
  Future<List<String>> pick(ServiceRequestImageSource source) async => const [
        '/tmp/foto-1.jpg',
        '/tmp/foto-2.jpg',
      ];
}

class _RecordingRequestRepository implements ServiceRequestRepository {
  ServiceRequestModel? created;
  ServiceRequestModel? updated;

  @override
  Future<ServiceRequestModel> createRequest(ServiceRequestModel request) async {
    created = request;
    return request;
  }

  @override
  Future<ServiceRequestModel?> getRequestById(String id) async => null;

  @override
  Future<List<ServiceRequestModel>> getRequests() async => const [];

  @override
  Future<List<ServiceRequestModel>> getRequestsByClient(String clientId) async =>
      const [];

  @override
  Future<ServiceRequestModel> updateRequest(
    ServiceRequestModel request,
  ) async {
    updated = request;
    return request;
  }
}
