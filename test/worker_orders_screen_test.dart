import 'package:fixgeo_app/core/enums/provider_type.dart';
import 'package:fixgeo_app/core/enums/service_request_status.dart';
import 'package:fixgeo_app/features/orders/screens/worker_orders_screen.dart';
import 'package:fixgeo_app/models/client_model.dart';
import 'package:fixgeo_app/models/service_model.dart';
import 'package:fixgeo_app/models/service_request_model.dart';
import 'package:fixgeo_app/models/worker_model.dart';
import 'package:fixgeo_app/repositories/client_repository.dart';
import 'package:fixgeo_app/repositories/service_repository.dart';
import 'package:fixgeo_app/repositories/service_request_repository.dart';
import 'package:fixgeo_app/repositories/worker_repository.dart';
import 'package:fixgeo_app/services/client_service.dart';
import 'package:fixgeo_app/services/request_service.dart';
import 'package:fixgeo_app/services/service_service.dart';
import 'package:fixgeo_app/services/worker_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeWorkerRepository implements WorkerRepository {
  _FakeWorkerRepository(this.worker);

  final WorkerModel worker;

  @override
  Future<WorkerModel?> getWorkerById(String id) async =>
      worker.id == id ? worker : null;

  @override
  Future<List<WorkerModel>> getWorkers() async => [worker];

  @override
  Future<List<WorkerModel>> getWorkersByService(String serviceId) async =>
      [worker];

  @override
  Future<List<WorkerModel>> getNearbyWorkers({
    required double latitude,
    required double longitude,
    required String serviceId,
    double radiusKm = 10,
  }) async =>
      [worker];
}

class _FakeServiceRepository implements ServiceRepository {
  _FakeServiceRepository(this.services);

  final List<ServiceModel> services;

  @override
  Future<ServiceModel?> getServiceById(String id) async {
    for (final s in services) {
      if (s.id == id) return s;
    }
    return null;
  }

  @override
  Future<List<ServiceModel>> getServices() async => services;
}

class _FakeClientRepository implements ClientRepository {
  _FakeClientRepository(this.clients);

  final List<ClientModel> clients;

  @override
  Future<ClientModel?> getClientById(String id) async {
    for (final c in clients) {
      if (c.id == id) return c;
    }
    return null;
  }

  @override
  Future<List<ClientModel>> getClients() async => clients;
}

class _FakeRequestRepository implements ServiceRequestRepository {
  _FakeRequestRepository(this.requests);

  final List<ServiceRequestModel> requests;

  @override
  Future<List<ServiceRequestModel>> getRequests() async => requests;

  @override
  Future<ServiceRequestModel?> getRequestById(String id) async {
    for (final r in requests) {
      if (r.id == id) return r;
    }
    return null;
  }

  @override
  Future<List<ServiceRequestModel>> getRequestsByClient(String clientId) async =>
      requests.where((r) => r.clientId == clientId).toList();

  @override
  Future<ServiceRequestModel> createRequest(ServiceRequestModel request) async =>
      request;

  @override
  Future<ServiceRequestModel> updateRequest(ServiceRequestModel request) async =>
      request;
}

void main() {
  late WorkerModel testWorker;
  late List<ServiceModel> testServices;
  late List<ClientModel> testClients;
  late List<ServiceRequestModel> testRequests;

  late WorkerService workerService;
  late ServiceService serviceService;
  late ClientService clientService;
  late RequestService requestService;

  setUp(() {
    testWorker = WorkerModel(
      id: 'worker_001',
      name: 'Carlos',
      lastName: 'Mendoza',
      email: 'carlos@fixgeo.example',
      phone: '+591 72000001',
      profileImage: '',
      latitude: -16.5010,
      longitude: -68.1490,
      address: 'Sopocachi, La Paz',
      isActive: true,
      isAvailable: true,
      rating: 4.8,
      reviewCount: 86,
      experience: 9,
      description: 'Especialista en instalaciones sanitarias y eléctricas.',
      coverageRadiusKm: 5,
      serviceIds: const ['service_plumbing', 'service_electricity'],
      createdAt: DateTime.utc(2025, 8, 10),
    );

    testServices = const [
      ServiceModel(
        id: 'service_plumbing',
        name: 'Plomería',
        description: 'Plomería general',
        icon: '',
        category: 'Hogar',
        examples: [],
        isActive: true,
      ),
      ServiceModel(
        id: 'service_electricity',
        name: 'Electricidad',
        description: 'Electricidad residencial',
        icon: '',
        category: 'Hogar',
        examples: [],
        isActive: true,
      ),
      ServiceModel(
        id: 'service_painting',
        name: 'Pintura',
        description: 'Pintura general',
        icon: '',
        category: 'Renovación',
        examples: [],
        isActive: true,
      ),
    ];

    testClients = [
      ClientModel(
        id: 'client_001',
        name: 'Lucía',
        lastName: 'Fernández',
        email: 'lucia@fixgeo.example',
        phone: '+591 70100001',
        profileImage: '',
        latitude: -16.5065,
        longitude: -68.1440,
        address: 'Calle Pedro Salazar 612',
        isActive: true,
        createdAt: DateTime.utc(2026, 1, 1),
      ),
      ClientModel(
        id: 'client_002',
        name: 'Diego',
        lastName: 'Vargas',
        email: 'diego@fixgeo.example',
        phone: '+591 70100002',
        profileImage: '',
        latitude: -16.5100,
        longitude: -68.1398,
        address: 'Avenida 20 de Octubre 2148',
        isActive: true,
        createdAt: DateTime.utc(2026, 1, 1),
      ),
      ClientModel(
        id: 'client_003',
        name: 'Mariana',
        lastName: 'Quiroga',
        email: 'mariana@fixgeo.example',
        phone: '+591 70100003',
        profileImage: '',
        latitude: -16.4875,
        longitude: -68.1628,
        address: 'Calle Ecuador 1881',
        isActive: true,
        createdAt: DateTime.utc(2026, 1, 1),
      ),
    ];

    final now = DateTime.now();
    testRequests = [
      // 1. Plomería, Lucía Fernández, NUEVA, ~0.8 km, Lo antes posible
      ServiceRequestModel(
        id: 'request_001',
        clientId: 'client_001',
        serviceId: 'service_plumbing',
        description:
            'Tengo una fuga debajo del lavamanos y se está filtrando agua.',
        latitude: -16.5065,
        longitude: -68.1440,
        address: 'Calle Pedro Salazar 612',
        images: const [],
        status: ServiceRequestStatus.pending,
        scheduledFor: null,
        selectedProviderId: null,
        selectedProviderType: null,
        createdAt: now.subtract(const Duration(minutes: 5)),
        updatedAt: now.subtract(const Duration(minutes: 5)),
      ),
      // 2. Electricidad, Diego Vargas, NUEVA, ~1.4 km, Hoy por la tarde
      ServiceRequestModel(
        id: 'request_002',
        clientId: 'client_002',
        serviceId: 'service_electricity',
        description: 'Necesito revisar una toma que dejó de funcionar.',
        latitude: -16.5100,
        longitude: -68.1398,
        address: 'Avenida 20 de Octubre 2148',
        images: const [],
        status: ServiceRequestStatus.pending,
        scheduledFor: DateTime(now.year, now.month, now.day, 16, 0),
        selectedProviderId: null,
        selectedProviderType: null,
        createdAt: now.subtract(const Duration(minutes: 20)),
        updatedAt: now.subtract(const Duration(minutes: 20)),
      ),
      // 3. Plomería, Mariana Quiroga, ACEPTADA por worker_001, ~2.1 km
      ServiceRequestModel(
        id: 'request_003',
        clientId: 'client_003',
        serviceId: 'service_plumbing',
        description: 'Revisión general del sistema de agua en la casa.',
        latitude: -16.4875,
        longitude: -68.1628,
        address: 'Calle Ecuador 1881',
        images: const [],
        status: ServiceRequestStatus.accepted,
        scheduledFor: DateTime(now.year, now.month, now.day)
            .add(const Duration(days: 1, hours: 10)),
        selectedProviderId: 'worker_001',
        selectedProviderType: ProviderType.worker,
        createdAt: now.subtract(const Duration(hours: 1)),
        updatedAt: now.subtract(const Duration(hours: 1)),
      ),
      // 4. Pintura (incompatible with Carlos -> not shown)
      ServiceRequestModel(
        id: 'request_004',
        clientId: 'client_001',
        serviceId: 'service_painting',
        description: 'Pintar sala.',
        latitude: -16.5065,
        longitude: -68.1440,
        address: 'Calle Pedro Salazar 612',
        images: const [],
        status: ServiceRequestStatus.pending,
        scheduledFor: null,
        selectedProviderId: null,
        selectedProviderType: null,
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
      // 5. Plomería outside coverage (>5 km -> not shown)
      ServiceRequestModel(
        id: 'request_005',
        clientId: 'client_002',
        serviceId: 'service_plumbing',
        description: 'Plomería lejos.',
        latitude: -16.5680,
        longitude: -68.1490,
        address: 'Calle 21 Calacoto',
        images: const [],
        status: ServiceRequestStatus.pending,
        scheduledFor: null,
        selectedProviderId: null,
        selectedProviderType: null,
        createdAt: now.subtract(const Duration(hours: 2)),
        updatedAt: now.subtract(const Duration(hours: 2)),
      ),
    ];

    workerService = WorkerService(_FakeWorkerRepository(testWorker));
    serviceService = ServiceService(_FakeServiceRepository(testServices));
    clientService = ClientService(_FakeClientRepository(testClients));
    requestService = RequestService(_FakeRequestRepository(testRequests));
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: WorkerOrdersScreen(
        worker: testWorker,
        workerService: workerService,
        requestService: requestService,
        clientService: clientService,
        serviceService: serviceService,
      ),
    );
  }

  testWidgets('renders header with Pedidos, availability switch, and coverage radius', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Screen title is "Pedidos"
    expect(find.text('Pedidos'), findsWidgets);
    expect(find.text('Solicitudes'), findsNothing);

    // Availability control
    expect(find.text('Disponible'), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);

    // Section title and coverage radius
    expect(find.text('Pedidos cercanos'), findsOneWidget);
    expect(find.text('Servicios solicitados dentro de tu zona'), findsOneWidget);
    expect(find.text('A 5 km'), findsOneWidget);

    // Filter counts: Todas (3), Nuevas (2), Aceptadas (1)
    expect(find.text('Todas (3)'), findsOneWidget);
    expect(find.text('Nuevas (2)'), findsOneWidget);
    expect(find.text('Aceptadas (1)'), findsOneWidget);

    // Incompatible requests (Pintura, >5 km) are excluded
    expect(find.text('Pintar sala.'), findsNothing);
    expect(find.text('Plomería lejos.'), findsNothing);

    // Pedido 1 and Pedido 2 content
    expect(
      find.text('Tengo una fuga debajo del lavamanos y se está filtrando agua.'),
      findsOneWidget,
    );
    expect(
      find.text('Necesito revisar una toma que dejó de funcionar.'),
      findsOneWidget,
    );
    expect(
      find.text('Revisión general del sistema de agua en la casa.'),
      findsOneWidget,
    );
  });

  testWidgets('filter tabs switch between Todas, Nuevas, and Aceptadas', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // In "Todas", all 3 orders are displayed
    expect(find.text('Lucía Fernández'), findsOneWidget);
    expect(find.text('Diego Vargas'), findsOneWidget);
    expect(find.text('Mariana Quiroga'), findsOneWidget);

    // Switch to "Nuevas"
    await tester.tap(find.text('Nuevas (2)'));
    await tester.pumpAndSettle();

    expect(find.text('Lucía Fernández'), findsOneWidget);
    expect(find.text('Diego Vargas'), findsOneWidget);
    expect(find.text('Mariana Quiroga'), findsNothing);

    // Switch to "Aceptadas"
    await tester.tap(find.text('Aceptadas (1)'));
    await tester.pumpAndSettle();

    expect(find.text('Lucía Fernández'), findsNothing);
    expect(find.text('Diego Vargas'), findsNothing);
    expect(find.text('Mariana Quiroga'), findsOneWidget);
  });

  testWidgets('toggling availability switch updates status and shows banner', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    expect(find.text('Disponible'), findsOneWidget);

    // Toggle switch to false
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    expect(find.text('No disponible'), findsOneWidget);
    expect(find.text('No disponible para nuevos pedidos'), findsOneWidget);

    // Nuevas count drops to 0
    expect(find.text('Nuevas (0)'), findsOneWidget);
    // Accepted requests are preserved
    expect(find.text('Aceptadas (1)'), findsOneWidget);
  });

  testWidgets('tapping order card navigates to WorkerRequestDetailScreen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Tap first card
    await tester.tap(
      find.text('Tengo una fuga debajo del lavamanos y se está filtrando agua.'),
    );
    await tester.pumpAndSettle();

    // Detail screen opened
    expect(find.text('Detalle del pedido'), findsOneWidget);
    expect(find.text('Descripción del trabajo'), findsOneWidget);
    expect(find.text('Calle Pedro Salazar 612'), findsOneWidget);
  });
}
