import 'package:fixgeo_app/data/mock/mock_clients.dart';
import 'package:fixgeo_app/data/mock/mock_companies.dart';
import 'package:fixgeo_app/data/mock/mock_workers.dart';
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
}
