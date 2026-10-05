import 'package:fixgeo_app/core/constants/app_strings.dart';
import 'package:fixgeo_app/data/mock/mock_clients.dart';
import 'package:fixgeo_app/features/account/screens/client_account_screen.dart';
import 'package:fixgeo_app/features/home/widgets/home_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('shows the client profile and account options', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(home: ClientAccountScreen()),
    );
    await tester.pump();

    expect(find.text(AppStrings.mockClientName), findsOneWidget);
    expect(find.text(AppStrings.clientRole), findsOneWidget);
    expect(find.text(AppStrings.settings), findsOneWidget);
    expect(find.text(AppStrings.myOrders), findsOneWidget);
    expect(find.text(AppStrings.discover), findsOneWidget);
    expect(find.text(AppStrings.howItWorks), findsOneWidget);
    expect(find.text(AppStrings.earnMoney), findsOneWidget);
    expect(find.text(AppStrings.exploreServices), findsOneWidget);
    expect(find.byType(HomeBottomNavigation), findsOneWidget);
  });

  testWidgets('hamburger opens the authenticated client side menu', (
    tester,
  ) async {
    final client = mockClients.first;
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(home: ClientAccountScreen(user: client)),
    );
    await tester.pump();

    expect(find.text(client.fullName), findsOneWidget);
    await tester.tap(find.byTooltip(AppStrings.openMenu));
    await tester.pumpAndSettle();

    expect(find.text(AppStrings.requestService), findsOneWidget);
    expect(find.text(client.fullName), findsWidgets);
    expect(find.text(AppStrings.homeTab), findsWidgets);
    expect(find.text(AppStrings.myOrders), findsWidgets);
    expect(find.text(AppStrings.discover), findsWidgets);
    expect(find.text(AppStrings.settings), findsWidgets);
    expect(find.text(AppStrings.becomeProvider), findsOneWidget);
    expect(find.text(AppStrings.signOut), findsOneWidget);
    expect(find.text(AppStrings.version), findsOneWidget);
    expect(find.text(AppStrings.whatsapp), findsOneWidget);
    expect(find.byTooltip(AppStrings.closeMenu), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('account remains structured on a compact phone', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(home: ClientAccountScreen(user: mockClients.first)),
    );
    await tester.pump();

    expect(find.text(mockClients.first.fullName), findsOneWidget);
    expect(find.text(AppStrings.accountTab), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
