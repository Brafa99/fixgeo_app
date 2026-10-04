import 'package:fixgeo_app/features/orders/screens/orders_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('orders shows its empty state and fixed navigation', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
    await tester.pump();

    expect(find.text('Explorar pedidos de otros clientes'), findsOneWidget);
    expect(find.text('Sin pedidos por ahora'), findsOneWidget);
    expect(find.text('¿Cómo funciona?'), findsOneWidget);
    expect(find.text('Inicio'), findsOneWidget);
    expect(find.text('Pedidos'), findsOneWidget);
    expect(find.text('Cuenta'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('orders remains usable on a compact phone', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(const MaterialApp(home: OrdersScreen()));
    await tester.pump();

    expect(find.text('Sin pedidos por ahora'), findsOneWidget);
    expect(find.text('Pedidos'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
