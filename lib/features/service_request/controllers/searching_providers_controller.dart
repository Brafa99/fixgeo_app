import 'package:flutter/foundation.dart';

import '../../../models/company_model.dart';
import '../../../models/service_model.dart';
import '../../../models/service_request_model.dart';
import '../../../models/user_model.dart';
import '../../../models/worker_model.dart';
import '../../../services/company_service.dart';
import '../../../services/worker_service.dart';
import '../models/nearby_providers_arguments.dart';

class SearchingProvidersController extends ChangeNotifier {
  SearchingProvidersController({
    required this.request,
    required this.service,
    required this.user,
    required WorkerService workerService,
    required CompanyService companyService,
  })  : _workerService = workerService,
        _companyService = companyService;

  final ServiceRequestModel request;
  final ServiceModel service;
  final UserModel? user;
  final WorkerService _workerService;
  final CompanyService _companyService;

  bool _workersReady = false;
  bool _companiesReady = false;
  bool _isComplete = false;
  String? _error;
  bool _isDisposed = false;

  bool get workersReady => _workersReady;
  bool get companiesReady => _companiesReady;
  bool get isComplete => _isComplete;
  String? get error => _error;

  Future<NearbyProvidersArguments?> search() async {
    _error = null;
    _workersReady = false;
    _companiesReady = false;
    _isComplete = false;
    _notify();
    try {
      final workersFuture = _workerService.getNearbyWorkers(
        latitude: request.latitude,
        longitude: request.longitude,
        serviceId: request.serviceId,
      );
      final companiesFuture = _companyService.getNearbyCompanies(
        latitude: request.latitude,
        longitude: request.longitude,
        serviceId: request.serviceId,
      );

      final workers = await workersFuture;
      _workersReady = true;
      _notify();
      final companies = await companiesFuture;
      _companiesReady = true;
      _notify();

      await Future<void>.delayed(const Duration(milliseconds: 650));
      _isComplete = true;
      _notify();
      return NearbyProvidersArguments(
        request: request,
        service: service,
        workers: List<WorkerModel>.unmodifiable(workers),
        companies: List<CompanyModel>.unmodifiable(companies),
        user: user,
      );
    } catch (_) {
      _error = 'No pudimos buscar prestadores. Intenta nuevamente.';
      _notify();
      return null;
    }
  }

  void _notify() {
    if (!_isDisposed) notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    super.dispose();
  }
}
