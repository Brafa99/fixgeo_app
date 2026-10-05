import 'package:fixgeo_app/core/constants/app_strings.dart';
import 'package:fixgeo_app/core/enums/user_role.dart';
import 'package:fixgeo_app/core/routes/route_names.dart';
import 'package:fixgeo_app/data/mock/services/mock_auth_service.dart';
import 'package:fixgeo_app/features/auth/screens/login_screen.dart';
import 'package:fixgeo_app/features/auth/services/auth_service.dart';
import 'package:fixgeo_app/models/user_model.dart';
import 'package:fixgeo_app/shared/widgets/app_back_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('mock credentials authenticate every account type', () async {
    final service = MockAuthService();

    final client = await service.signIn(
      identifier: 'lucia.fernandez@clientes.fixgeo.example',
      password: 'FixGeo.Cliente01!',
    );
    final worker = await service.signIn(
      identifier: 'carlos.mendoza@trabajadores.fixgeo.example',
      password: 'FixGeo.Trabajador01!',
    );
    final company = await service.signIn(
      identifier: 'contacto@andinahogar.fixgeo.example',
      password: 'FixGeo.Empresa01!',
    );

    expect(client.role, UserRole.client);
    expect(worker.role, UserRole.worker);
    expect(company.role, UserRole.company);
  });

  test('mock login accepts a phone without formatting', () async {
    final user = await MockAuthService().signIn(
      identifier: '59170100001',
      password: 'FixGeo.Cliente01!',
    );

    expect(user.id, 'client_001');
  });

  test('mock login rejects an invalid password', () async {
    await expectLater(
      MockAuthService().signIn(
        identifier: 'lucia.fernandez@clientes.fixgeo.example',
        password: 'incorrecta',
      ),
      throwsA(isA<AuthException>()),
    );
  });

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

  testWidgets('valid credentials open the shared home', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const LoginScreen(),
        routes: {
          RouteNames.accountType: (_) => const Scaffold(),
          RouteNames.home: (_) => const _AuthenticatedHomeProbe(),
        },
      ),
    );

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'lucia.fernandez@clientes.fixgeo.example',
    );
    await tester.enterText(
      find.byType(TextFormField).at(1),
      'FixGeo.Cliente01!',
    );
    await tester.tap(find.text(AppStrings.signIn));
    await tester.pumpAndSettle();

    expect(find.text('Hola, Lucía'), findsOneWidget);
    expect(find.byType(LoginScreen), findsNothing);
  });

  testWidgets('invalid credentials show an error and remain on login', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: const LoginScreen(),
        routes: {
          RouteNames.accountType: (_) => const Scaffold(),
        },
      ),
    );

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'lucia.fernandez@clientes.fixgeo.example',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'incorrecta');
    await tester.tap(find.text(AppStrings.signIn));
    await tester.pumpAndSettle();

    expect(find.text('Usuario o contraseña incorrectos.'), findsOneWidget);
    expect(find.byType(LoginScreen), findsOneWidget);
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

class _AuthenticatedHomeProbe extends StatelessWidget {
  const _AuthenticatedHomeProbe();

  @override
  Widget build(BuildContext context) {
    final user = ModalRoute.of(context)!.settings.arguments! as UserModel;
    return Scaffold(body: Text('Hola, ${user.name}'));
  }
}
