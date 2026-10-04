import 'package:fixgeo_app/core/constants/app_strings.dart';
import 'package:fixgeo_app/core/routes/route_names.dart';
import 'package:fixgeo_app/features/auth/screens/login_screen.dart';
import 'package:fixgeo_app/shared/widgets/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('login remains usable on a compact phone', (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: const LoginScreen(),
        routes: {
          RouteNames.home: (_) => const Scaffold(body: Text('Inicio')),
          RouteNames.accountType: (_) => const Scaffold(),
        },
      ),
    );
    await tester.pump();

    expect(find.text(AppStrings.loginWelcome), findsOneWidget);
    expect(find.text(AppStrings.signIn), findsOneWidget);
    expect(find.text(AppStrings.createAccount), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('back returns to the previous screen', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const _LoginLauncher(),
        routes: {
          RouteNames.home: (_) => const Scaffold(body: Text('Inicio')),
          RouteNames.accountType: (_) => const Scaffold(),
        },
      ),
    );

    await tester.tap(find.text('Abrir login'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(AppBackButton));
    await tester.pumpAndSettle();

    expect(find.text('Pantalla anterior'), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('back opens home when login has no previous screen', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const LoginScreen(),
        routes: {
          RouteNames.home: (_) => const Scaffold(body: Text('Inicio')),
          RouteNames.accountType: (_) => const Scaffold(),
        },
      ),
    );

    await tester.tap(find.byType(AppBackButton));
    await tester.pumpAndSettle();

    expect(find.text('Inicio'), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });
}

class _LoginLauncher extends StatelessWidget {
  const _LoginLauncher();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Pantalla anterior'),
          TextButton(
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (_) => const LoginScreen(),
              ),
            ),
            child: const Text('Abrir login'),
          ),
        ],
      ),
    );
  }
}
