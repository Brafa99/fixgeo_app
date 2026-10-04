import 'package:fixgeo_app/features/worker_registration/controllers/worker_registration_controller.dart';
import 'package:fixgeo_app/features/worker_registration/controllers/worker_registration_validators.dart';
import 'package:fixgeo_app/features/worker_registration/models/worker_registration_data.dart';
import 'package:fixgeo_app/features/worker_registration/screens/worker_basic_data_screen.dart';
import 'package:fixgeo_app/features/worker_registration/screens/worker_contact_screen.dart';
import 'package:fixgeo_app/features/worker_registration/services/worker_registration_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('worker controller preserves all values between steps', () {
    final controller = WorkerRegistrationController();
    addTearDown(controller.dispose);

    controller.updateBasicData(
      firstName: 'María',
      lastName: 'Flores',
      document: '7654321',
      city: 'Cochabamba',
    );
    controller.updatePresentation('Electricista con experiencia.');
    controller.updateContact(
      phone: '71234567',
      email: 'maria@fixgeo.com',
      password: 'Fixgeo123',
      confirmPassword: 'Fixgeo123',
    );
    controller.toggleCategory('electricity');
    controller.setAcceptedTerms(true);

    expect(controller.data.firstName, 'María');
    expect(controller.data.city, 'Cochabamba');
    expect(controller.data.presentation, contains('Electricista'));
    expect(controller.data.phone, '71234567');
    expect(controller.data.categories, ['electricity']);
    expect(controller.data.acceptedTerms, isTrue);
  });

  test('worker submit keeps backend operations separated and ordered',
      () async {
    final service = _FakeRegistrationService();
    final controller = WorkerRegistrationController(service: service);
    addTearDown(controller.dispose);
    controller
      ..updateContact(email: 'trabajador@fixgeo.com')
      ..toggleCategory('painting');

    await controller.submit();

    expect(service.calls, [
      'auth',
      'image:worker-user',
      'profile:worker-user',
      'services:worker-profile:painting',
    ]);
  });

  test('worker validators enforce required access data', () {
    expect(WorkerRegistrationValidators.document('1234567'), isNull);
    expect(WorkerRegistrationValidators.document('12'), isNotNull);
    expect(WorkerRegistrationValidators.phone('71234567'), isNull);
    expect(WorkerRegistrationValidators.phone('123'), isNotNull);
    expect(WorkerRegistrationValidators.optionalEmail(''), isNull);
    expect(
      WorkerRegistrationValidators.optionalEmail('correo-invalido'),
      isNotNull,
    );
    expect(WorkerRegistrationValidators.password('Fixgeo123'), isNull);
    expect(WorkerRegistrationValidators.password('Fixgeo123!'), isNull);
    expect(WorkerRegistrationValidators.password('sololetras'), isNotNull);
  });

  testWidgets('phone and password fields remain editable', (tester) async {
    final controller = WorkerRegistrationController();
    addTearDown(controller.dispose);
    await tester.binding.setSurfaceSize(const Size(360, 740));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(home: WorkerContactScreen(controller: controller)),
    );

    final fields = find.byType(TextFormField);
    expect(fields, findsNWidgets(4));

    await tester.enterText(fields.at(0), '71234567');
    await tester.enterText(fields.at(2), 'Fixgeo123!');
    expect(controller.data.phone, '71234567');
    expect(controller.data.password, 'Fixgeo123!');

    await tester.enterText(fields.at(2), 'Nueva9');
    expect(controller.data.password, 'Nueva9');

    await tester.enterText(fields.at(2), '');
    expect(controller.data.password, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('worker registration first step fits on a compact phone', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 568));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      const MaterialApp(home: WorkerBasicDataScreen()),
    );
    await tester.pump();

    expect(find.text('Registro de trabajadores'), findsOneWidget);
    expect(find.text('Tus datos básicos'), findsOneWidget);
    expect(find.text('Siguiente'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

class _FakeRegistrationService implements WorkerRegistrationService {
  final calls = <String>[];

  @override
  Future<String> createAuthUser(WorkerRegistrationData data) async {
    calls.add('auth');
    return 'worker-user';
  }

  @override
  Future<String?> uploadProfileImage(String userId, String? imagePath) async {
    calls.add('image:$userId');
    return null;
  }

  @override
  Future<String> createWorkerProfile(
    WorkerRegistrationData data, {
    required String userId,
    String? imageUrl,
  }) async {
    calls.add('profile:$userId');
    return 'worker-profile';
  }

  @override
  Future<void> associateServices(
    String workerId,
    List<String> categoryIds,
  ) async {
    calls.add('services:$workerId:${categoryIds.join(',')}');
  }
}
