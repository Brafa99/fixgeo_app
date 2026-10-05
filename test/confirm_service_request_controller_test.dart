import 'package:fixgeo_app/core/enums/service_request_status.dart';
import 'package:fixgeo_app/data/mock/mock_companies.dart';
import 'package:fixgeo_app/data/mock/mock_requests.dart';
import 'package:fixgeo_app/data/mock/mock_services.dart';
import 'package:fixgeo_app/data/mock/mock_workers.dart';
import 'package:fixgeo_app/data/mock/repositories/mock_company_repository.dart';
import 'package:fixgeo_app/data/mock/repositories/mock_service_repository.dart';
import 'package:fixgeo_app/data/mock/repositories/mock_service_request_repository.dart';
import 'package:fixgeo_app/data/mock/repositories/mock_worker_repository.dart';
import 'package:fixgeo_app/features/service_request/controllers/confirm_service_request_controller.dart';
import 'package:fixgeo_app/features/service_request/controllers/searching_providers_controller.dart';
import 'package:fixgeo_app/services/company_service.dart';
import 'package:fixgeo_app/services/request_service.dart';
import 'package:fixgeo_app/services/service_service.dart';
import 'package:fixgeo_app/services/worker_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('loads category information through ServiceService', () async {
    final controller = _buildController();
    addTearDown(controller.dispose);

    await controller.initialize();

    expect(controller.service?.id, mockRequests.first.serviceId);
    expect(controller.service?.name, 'Plomería');
    expect(controller.error, isNull);
  });

  test('updates request to searching before provider lookup', () async {
    final repository = MockServiceRequestRepository(
      requests: [mockRequests.first],
    );
    final controller = _buildController(requestRepository: repository);
    addTearDown(controller.dispose);
    await controller.initialize();

    final request = await controller.startProviderSearch();

    expect(request, isNotNull);
    expect(request?.status, ServiceRequestStatus.searching);
    expect(
      (await repository.getRequestById(mockRequests.first.id))?.status,
      ServiceRequestStatus.searching,
    );
  });

  test('searching step resolves nearby workers and companies', () async {
    final controller = SearchingProvidersController(
      request: mockRequests.first,
      service: mockServices.first,
      user: null,
      workerService: WorkerService(
        MockWorkerRepository(workers: mockWorkers),
      ),
      companyService: CompanyService(
        MockCompanyRepository(companies: mockCompanies),
      ),
    );
    addTearDown(controller.dispose);

    final results = await controller.search();

    expect(results?.workers.map((worker) => worker.id), [
      'worker_001',
      'worker_005',
    ]);
    expect(results?.companies.map((company) => company.id), ['company_001']);
  });
}

ConfirmServiceRequestController _buildController({
  MockServiceRequestRepository? requestRepository,
}) {
  return ConfirmServiceRequestController(
    request: mockRequests.first,
    user: null,
    serviceService: ServiceService(
      MockServiceRepository(services: mockServices),
    ),
    requestService: RequestService(
      requestRepository ??
          MockServiceRequestRepository(requests: [mockRequests.first]),
    ),
    clock: () => DateTime.utc(2026, 10, 4, 16),
  );
}
