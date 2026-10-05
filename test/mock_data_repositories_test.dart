import 'package:fixgeo_app/core/utils/distance_calculator.dart';
import 'package:fixgeo_app/data/mock/mock_clients.dart';
import 'package:fixgeo_app/data/mock/mock_companies.dart';
import 'package:fixgeo_app/data/mock/mock_services.dart';
import 'package:fixgeo_app/data/mock/mock_requests.dart';
import 'package:fixgeo_app/data/mock/mock_workers.dart';
import 'package:fixgeo_app/data/mock/repositories/mock_company_repository.dart';
import 'package:fixgeo_app/data/mock/repositories/mock_worker_repository.dart';
import 'package:fixgeo_app/models/company_model.dart';
import 'package:fixgeo_app/models/service_model.dart';
import 'package:fixgeo_app/models/service_request_model.dart';
import 'package:fixgeo_app/models/worker_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('mock catalog', () {
    test('contains stable fixture counts and ids', () {
      expect(mockClients, hasLength(5));
      expect(mockWorkers, hasLength(5));
      expect(mockCompanies, hasLength(3));
      expect(mockServices, hasLength(8));

      expect(mockClients.map((client) => client.id).toSet(), hasLength(5));
      expect(mockWorkers.map((worker) => worker.id).toSet(), hasLength(5));
      expect(mockCompanies.map((company) => company.id).toSet(), hasLength(3));
      expect(mockServices.map((service) => service.id).toSet(), hasLength(8));
    });

    test('worker and company JSON round trips preserve domain fields', () {
      final worker = WorkerModel.fromJson(mockWorkers.first.toJson());
      final company = CompanyModel.fromJson(mockCompanies.first.toJson());

      expect(worker.id, mockWorkers.first.id);
      expect(worker.serviceIds, mockWorkers.first.serviceIds);
      expect(worker.role, mockWorkers.first.role);
      expect(company.id, mockCompanies.first.id);
      expect(company.commercialName, mockCompanies.first.commercialName);
      expect(company.logo, mockCompanies.first.logo);
    });

    test('service JSON round trip preserves request examples', () {
      final service = ServiceModel.fromJson(mockServices.first.toJson());

      expect(service.id, mockServices.first.id);
      expect(service.examples, mockServices.first.examples);
    });

    test('request JSON round trip preserves the optional scheduled date', () {
      final scheduled = DateTime.utc(2026, 10, 8);
      final original = mockRequests.first.copyWith(scheduledFor: scheduled);
      final request = ServiceRequestModel.fromJson(original.toJson());

      expect(request.scheduledFor, scheduled);
      expect(request.status, original.status);
      expect(request.images, original.images);
    });
  });

  group('nearby providers', () {
    test('filters and sorts available workers by distance', () async {
      final repository = MockWorkerRepository();

      final workers = await repository.getNearbyWorkers(
        latitude: -16.5000,
        longitude: -68.1500,
        serviceId: 'service_plumbing',
      );

      expect(workers.map((worker) => worker.id), [
        'worker_001',
        'worker_005',
      ]);
      final distances = workers
          .map(
            (worker) => calculateDistanceKm(
              -16.5000,
              -68.1500,
              worker.latitude,
              worker.longitude,
            ),
          )
          .toList();
      expect(distances.first, lessThan(distances.last));
    });

    test('excludes unavailable workers', () async {
      final repository = MockWorkerRepository();

      final workers = await repository.getNearbyWorkers(
        latitude: -16.5000,
        longitude: -68.1500,
        serviceId: 'service_electricity',
      );

      expect(workers.map((worker) => worker.id), ['worker_001']);
    });

    test('finds active companies by service and distance', () async {
      final repository = MockCompanyRepository();

      final companies = await repository.getNearbyCompanies(
        latitude: -16.5000,
        longitude: -68.1500,
        serviceId: 'service_plumbing',
        radiusKm: 5,
      );

      expect(companies.map((company) => company.id), ['company_001']);
    });
  });
}
