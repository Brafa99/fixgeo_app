import 'dart:async';

import 'package:fixgeo_app/core/constants/app_strings.dart';
import 'package:fixgeo_app/core/routes/route_names.dart';
import 'package:fixgeo_app/data/mock/mock_clients.dart';
import 'package:fixgeo_app/data/mock/mock_services.dart';
import 'package:fixgeo_app/features/categories/screens/service_category_detail_screen.dart';
import 'package:fixgeo_app/features/service_request/models/create_service_request_arguments.dart';
import 'package:fixgeo_app/models/service_model.dart';
import 'package:fixgeo_app/repositories/service_repository.dart';
import 'package:fixgeo_app/services/service_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('loads the selected service and renders its real catalog data', (
    tester,
  ) async {
    final plumbing = mockServices.firstWhere(
      (service) => service.id == 'service_plumbing',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ServiceCategoryDetailScreen(
          serviceId: plumbing.id,
          serviceService: const ServiceService(_CatalogRepository()),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text(plumbing.name), findsAtLeastNWidgets(1));
    expect(find.text(plumbing.description), findsOneWidget);
    expect(find.text(AppStrings.requestableServices), findsOneWidget);
    expect(find.text(plumbing.examples.first), findsOneWidget);
    expect(find.text(AppStrings.requestService), findsOneWidget);
  });

  testWidgets('shows a loading state while the repository is resolving', (
    tester,
  ) async {
    final completer = Completer<ServiceModel?>();
    final service = ServiceService(
      _ControlledRepository(loadById: (_) => completer.future),
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ServiceCategoryDetailScreen(
          serviceId: 'service_plumbing',
          serviceService: service,
        ),
      ),
    );
    await tester.pump();

    expect(find.text(AppStrings.loadingService), findsOneWidget);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(mockServices.first);
    await tester.pumpAndSettle();
  });

  testWidgets('request action forwards service and logged client', (
    tester,
  ) async {
    CreateServiceRequestArguments? receivedArguments;
    final electricity = mockServices.firstWhere(
      (service) => service.id == 'service_electricity',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ServiceCategoryDetailScreen(
          serviceId: electricity.id,
          user: mockClients.first,
          serviceService: const ServiceService(_CatalogRepository()),
        ),
        onGenerateRoute: (settings) {
          if (settings.name != RouteNames.createServiceRequest) return null;
          receivedArguments =
              settings.arguments! as CreateServiceRequestArguments;
          return MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('Crear solicitud')),
            settings: settings,
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text(AppStrings.requestService));
    await tester.pumpAndSettle();

    expect(receivedArguments?.serviceId, electricity.id);
    expect(receivedArguments?.user?.id, mockClients.first.id);
    expect(find.text('Crear solicitud'), findsOneWidget);
  });

  testWidgets('shows not-found and repository error states', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: ServiceCategoryDetailScreen(
          serviceId: 'missing',
          serviceService: ServiceService(
            _ControlledRepository(loadById: (_) async => null),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.serviceNotFound), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: ServiceCategoryDetailScreen(
          serviceId: 'service_plumbing',
          serviceService: ServiceService(
            _ControlledRepository(
              loadById: (_) => Future.error(StateError('network')),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.serviceLoadError), findsOneWidget);
    expect(find.text(AppStrings.retry), findsOneWidget);
  });
}

class _CatalogRepository implements ServiceRepository {
  const _CatalogRepository();

  @override
  Future<ServiceModel?> getServiceById(String id) async {
    for (final service in mockServices) {
      if (service.id == id) return service;
    }
    return null;
  }

  @override
  Future<List<ServiceModel>> getServices() async => mockServices;
}

class _ControlledRepository implements ServiceRepository {
  const _ControlledRepository({required this.loadById});

  final Future<ServiceModel?> Function(String id) loadById;

  @override
  Future<ServiceModel?> getServiceById(String id) => loadById(id);

  @override
  Future<List<ServiceModel>> getServices() async => const [];
}
