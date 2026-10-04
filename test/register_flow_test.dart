import 'package:fixgeo_app/features/register/controllers/register_controller.dart';
import 'package:fixgeo_app/features/register/controllers/register_validators.dart';
import 'package:fixgeo_app/features/register/screens/register_step_one_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('register controller preserves data between steps', () {
    final controller = RegisterController();
    addTearDown(controller.dispose);

    controller.updatePersonalData(
      firstName: 'Ana',
      lastName: 'Rojas',
      city: 'La Paz',
    );
    controller.updateContactData(phone: '71234567', email: 'ana@test.com');
    controller.updateAccessData(
      password: 'Fixgeo123',
      confirmPassword: 'Fixgeo123',
      acceptedTerms: true,
    );

    expect(controller.data.firstName, 'Ana');
    expect(controller.data.city, 'La Paz');
    expect(controller.data.phone, '71234567');
    expect(controller.canSubmit, isTrue);
  });

  test('register validators enforce phone, email and password rules', () {
    expect(RegisterValidators.bolivianPhone('71234567'), isNull);
    expect(RegisterValidators.bolivianPhone('123'), isNotNull);
    expect(RegisterValidators.optionalEmail(''), isNull);
    expect(RegisterValidators.optionalEmail('correo-invalido'), isNotNull);
    expect(RegisterValidators.password('Fixgeo123'), isNull);
    expect(RegisterValidators.password('sololetras'), isNotNull);
  });

  testWidgets('first registration step fits on a compact phone',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(home: RegisterStepOneScreen()),
    );
    await tester.pump();

    expect(find.text('Registro de clientes'), findsOneWidget);
    expect(find.text('Datos personales'), findsOneWidget);
    expect(find.text('Siguiente'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
