import 'package:fixgeo_app/core/constants/app_strings.dart';
import 'package:fixgeo_app/core/routes/app_routes.dart';
import 'package:fixgeo_app/data/mock/mock_clients.dart';
import 'package:fixgeo_app/data/mock/mock_companies.dart';
import 'package:fixgeo_app/data/mock/mock_workers.dart';
import 'package:fixgeo_app/features/account/screens/account_menu_screen.dart';
import 'package:fixgeo_app/features/account/screens/client_account_screen.dart';
import 'package:fixgeo_app/features/home/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('home keeps its primary content usable on a compact phone', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pump();

    expect(find.text('¿Te ayudo a solucionar algo?'), findsOneWidget);
    expect(find.text('Paraguay'), findsOneWidget);
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Pedidos'), findsOneWidget);
    expect(find.text('Cuenta'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('home exposes the reference sections while scrolling', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
    await tester.pump();

    expect(find.text('Casos de éxito recientes'), findsOneWidget);

    await tester.drag(
      find.byType(CustomScrollView),
      const Offset(0, -1100),
    );
    await tester.pumpAndSettle();

    expect(find.text('Nuestras redes sociales'), findsOneWidget);
    expect(find.text('WhatsApp'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('home greets authenticated clients, workers and companies', (
    tester,
  ) async {
    final users = [mockClients.first, mockWorkers.first, mockCompanies.first];

    for (final user in users) {
      await tester.pumpWidget(MaterialApp(home: HomeScreen(user: user)));
      await tester.pump();

      expect(find.text('Hola, ${user.name}'), findsOneWidget);
      expect(find.text('Entrar'), findsNothing);
      expect(tester.takeException(), isNull);
    }
  });

  testWidgets('pressing Cuenta when not logged in opens guest AccountMenuScreen', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: HomeScreen(),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Cuenta'));
    await tester.pumpAndSettle();

    expect(find.byType(AccountMenuScreen), findsOneWidget);
    expect(find.byType(ClientAccountScreen), findsNothing);
    expect(find.text(AppStrings.login), findsOneWidget);
    expect(find.text(AppStrings.register), findsOneWidget);
    expect(find.text(AppStrings.requestService), findsOneWidget);
  });

  testWidgets('pressing Cuenta when logged in does NOT open guest AccountMenuScreen', (
    tester,
  ) async {
    final client = mockClients.first;
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        onGenerateRoute: AppRoutes.onGenerateRoute,
        home: HomeScreen(user: client),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Cuenta'));
    await tester.pumpAndSettle();

    expect(find.byType(AccountMenuScreen), findsNothing);
    expect(find.byType(ClientAccountScreen), findsOneWidget);
    expect(find.text(client.fullName), findsOneWidget);
  });
}

