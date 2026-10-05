import 'package:fixgeo_app/core/routes/route_names.dart';
import 'package:fixgeo_app/data/mock/mock_clients.dart';
import 'package:fixgeo_app/data/mock/mock_services.dart';
import 'package:fixgeo_app/data/mock/repositories/mock_client_repository.dart';
import 'package:fixgeo_app/data/mock/repositories/mock_service_repository.dart';
import 'package:fixgeo_app/features/service_request/models/confirm_service_request_arguments.dart';
import 'package:fixgeo_app/features/service_request/screens/create_service_request_screen.dart';
import 'package:fixgeo_app/features/service_request/services/service_request_image_picker.dart';
import 'package:fixgeo_app/models/service_request_model.dart';
import 'package:fixgeo_app/repositories/service_request_repository.dart';
import 'package:fixgeo_app/services/client_service.dart';
import 'package:fixgeo_app/services/request_service.dart';
import 'package:fixgeo_app/services/service_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('creates a request and opens confirmation with typed arguments', (
    tester,
  ) async {
    ConfirmServiceRequestArguments? receivedArguments;

    await tester.pumpWidget(
      MaterialApp(
        home: CreateServiceRequestScreen(
          serviceId: 'service_plumbing',
          user: mockClients.first,
          serviceService: ServiceService(
            MockServiceRepository(services: mockServices),
          ),
          clientService: ClientService(
            MockClientRepository(clients: mockClients),
          ),
          requestService: RequestService(_RequestRepository()),
          imagePicker: const _NoopImagePicker(),
          clock: () => DateTime.utc(2026, 10, 4, 14, 30),
        ),
        onGenerateRoute: (settings) {
          if (settings.name != RouteNames.confirmServiceRequest) return null;
          receivedArguments =
              settings.arguments! as ConfirmServiceRequestArguments;
          return MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('Confirmar solicitud')),
            settings: settings,
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Pedir servicio (${mockServices.first.name})'),
      findsOneWidget,
    );
    expect(
      tester.getSize(
        find.byKey(const ValueKey('request-bottom-action')),
      ).height,
      lessThan(100),
    );

    await tester.enterText(
      find.byKey(const ValueKey('request-description-field')),
      'Tengo una fuga debajo del lavamanos y necesito una revisión.',
    );
    await tester.pump();
    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(find.text('Ubicación y fecha'), findsOneWidget);
    expect(find.text(mockClients.first.address), findsOneWidget);

    await tester.tap(find.text('Continuar'));
    await tester.pumpAndSettle();

    expect(receivedArguments?.request.clientId, mockClients.first.id);
    expect(receivedArguments?.request.serviceId, 'service_plumbing');
    expect(receivedArguments?.serviceName, mockServices.first.name);
    expect(find.text('Confirmar solicitud'), findsOneWidget);
  });
}

class _NoopImagePicker implements ServiceRequestImagePicker {
  const _NoopImagePicker();

  @override
  Future<List<String>> pick(ServiceRequestImageSource source) async => const [];
}

class _RequestRepository implements ServiceRequestRepository {
  @override
  Future<ServiceRequestModel> createRequest(ServiceRequestModel request) async =>
      request;

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
  ) async =>
      request;
}
