import 'dart:async';

import 'package:fixgeo_app/core/constants/app_strings.dart';
import 'package:fixgeo_app/core/routes/route_names.dart';
import 'package:fixgeo_app/data/mock/mock_clients.dart';
import 'package:fixgeo_app/data/mock/mock_services.dart';
import 'package:fixgeo_app/features/categories/screens/all_categories_screen.dart';
import 'package:fixgeo_app/features/categories/models/service_category_detail_arguments.dart';
import 'package:fixgeo_app/features/home/screens/home_screen.dart';
import 'package:fixgeo_app/models/service_model.dart';
import 'package:fixgeo_app/repositories/service_repository.dart';
import 'package:fixgeo_app/services/service_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('home more category opens the complete catalog', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(user: mockClients.first),
        routes: {
          RouteNames.login: (_) => const Scaffold(),
          RouteNames.allCategories: (_) =>
              const Scaffold(body: Text('Catálogo completo')),
        },
      ),
    );
    await tester.pump();

    await tester.tap(find.byKey(const ValueKey('home-category-more')));
    await tester.pumpAndSettle();

    expect(find.text('Catálogo completo'), findsOneWidget);
  });

  testWidgets('loads providers and services through the service layer', (
    tester,
  ) async {
    final completer = Completer<List<ServiceModel>>();
    final service =
        ServiceService(_TestServiceRepository(() => completer.future));

    await tester.pumpWidget(
      MaterialApp(home: AllCategoriesScreen(serviceService: service)),
    );
    await tester.pump();

    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    completer.complete(mockServices);
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.explore), findsOneWidget);
    expect(find.text(AppStrings.providersAndCompanies), findsOneWidget);
    expect(find.text(AppStrings.services), findsOneWidget);
    expect(find.byKey(const ValueKey('provider-worker_001')), findsOneWidget);
    expect(find.byKey(const ValueKey('provider-company_001')), findsOneWidget);
    expect(find.text('Plomería'), findsOneWidget);
    expect(find.text('Mantenimiento'), findsOneWidget);
    final grid = tester.widget<SliverGrid>(find.byType(SliverGrid));
    final delegate =
        grid.gridDelegate as SliverGridDelegateWithFixedCrossAxisCount;
    expect(delegate.crossAxisCount, 3);
  });

  testWidgets('selecting a category opens its detail using the stable id', (
    tester,
  ) async {
    ServiceCategoryDetailArguments? receivedArguments;
    await tester.pumpWidget(
      MaterialApp(
        home: AllCategoriesScreen(
          user: mockClients.first,
          serviceService: ServiceService(
            _TestServiceRepository(() async => mockServices),
          ),
        ),
        onGenerateRoute: (settings) {
          if (settings.name != RouteNames.serviceCategoryDetail) return null;
          receivedArguments =
              settings.arguments! as ServiceCategoryDetailArguments;
          return MaterialPageRoute<void>(
            builder: (_) => const Scaffold(body: Text('Detalle del servicio')),
            settings: settings,
          );
        },
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(
      find.byKey(const ValueKey('service-category-service_plumbing')),
    );
    await tester.pumpAndSettle();

    expect(receivedArguments?.serviceId, 'service_plumbing');
    expect(receivedArguments?.user?.id, 'client_001');
    expect(find.text('Detalle del servicio'), findsOneWidget);
  });

  testWidgets('shows empty and error states', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: AllCategoriesScreen(
          serviceService: ServiceService(
            _TestServiceRepository(() async => const []),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.noCategories), findsOneWidget);

    await tester.pumpWidget(
      MaterialApp(
        home: AllCategoriesScreen(
          serviceService: ServiceService(
            _TestServiceRepository(() => Future.error(StateError('network'))),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text(AppStrings.categoriesLoadError), findsOneWidget);
    expect(find.text(AppStrings.tryAgain), findsOneWidget);
    expect(find.text(AppStrings.retry), findsOneWidget);
  });
}

class _TestServiceRepository implements ServiceRepository {
  const _TestServiceRepository(this._loadServices);

  final Future<List<ServiceModel>> Function() _loadServices;

  @override
  Future<ServiceModel?> getServiceById(String id) async {
    final services = await _loadServices();
    for (final service in services) {
      if (service.id == id) return service;
    }
    return null;
  }

  @override
  Future<List<ServiceModel>> getServices() => _loadServices();
}
