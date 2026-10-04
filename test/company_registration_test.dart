import 'package:fixgeo_app/features/company_registration/controllers/company_registration_controller.dart';
import 'package:fixgeo_app/features/company_registration/controllers/company_registration_validators.dart';
import 'package:fixgeo_app/features/company_registration/models/company_registration_data.dart';
import 'package:fixgeo_app/features/company_registration/screens/company_business_data_screen.dart';
import 'package:fixgeo_app/features/company_registration/services/company_registration_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('company controller preserves all values between steps', () {
    final controller = CompanyRegistrationController();
    addTearDown(controller.dispose);

    controller.updateBusinessData(
      companyName: 'PuntoFix E.A.S.',
      presentation: 'Soluciones integrales para el hogar.',
    );
    controller.updateRepresentative(
      name: 'Juan',
      lastName: 'González',
      document: '1234567',
      city: 'La Paz',
    );
    controller.updateContact(
      phone: '71234567',
      email: 'empresa@fixgeo.com',
      password: 'Fixgeo123',
      confirmPassword: 'Fixgeo123',
    );
    controller.toggleService('electricity');
    controller.setAcceptedTerms(true);

    expect(controller.data.companyName, 'PuntoFix E.A.S.');
    expect(controller.data.representativeName, 'Juan');
    expect(controller.data.city, 'La Paz');
    expect(controller.data.phone, '71234567');
    expect(controller.data.services, ['electricity']);
    expect(controller.data.acceptedTerms, isTrue);
  });

  test('company submit keeps backend operations separated and ordered',
      () async {
    final service = _FakeCompanyRegistrationService();
    final controller = CompanyRegistrationController(service: service);
    addTearDown(controller.dispose);
    controller
      ..updateBusinessData(companyName: 'FixGeo Empresa')
      ..toggleService('cleaning');

    await controller.submit();

    expect(service.calls, [
      'auth',
      'logo:company-user',
      'company:company-user',
      'services:company-profile:cleaning',
    ]);
  });

  test('company validators enforce required access data', () {
    expect(CompanyRegistrationValidators.document('1234567'), isNull);
    expect(CompanyRegistrationValidators.document('12'), isNotNull);
    expect(CompanyRegistrationValidators.phone('71234567'), isNull);
    expect(CompanyRegistrationValidators.phone('123'), isNotNull);
    expect(CompanyRegistrationValidators.optionalEmail(''), isNull);
    expect(
      CompanyRegistrationValidators.optionalEmail('correo-invalido'),
      isNotNull,
    );
    expect(CompanyRegistrationValidators.password('Fixgeo123'), isNull);
    expect(CompanyRegistrationValidators.password('sololetras'), isNotNull);
  });

  testWidgets('company registration first step fits on a compact phone', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(home: CompanyBusinessDataScreen()),
    );
    await tester.pump();

    expect(find.text('Registro de Empresas'), findsOneWidget);
    expect(find.text('Datos de tu\nNegocio/Empresa'), findsOneWidget);
    expect(find.text('Siguiente'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FakeCompanyRegistrationService implements CompanyRegistrationService {
  final calls = <String>[];

  @override
  Future<String> createAuthUser(CompanyRegistrationData data) async {
    calls.add('auth');
    return 'company-user';
  }

  @override
  Future<String?> uploadCompanyLogo(String userId, String? logoPath) async {
    calls.add('logo:$userId');
    return null;
  }

  @override
  Future<String> createCompany(
    CompanyRegistrationData data, {
    required String userId,
    String? logoUrl,
  }) async {
    calls.add('company:$userId');
    return 'company-profile';
  }

  @override
  Future<void> associateServices(
    String companyId,
    List<String> serviceIds,
  ) async {
    calls.add('services:$companyId:${serviceIds.join(',')}');
  }
}
