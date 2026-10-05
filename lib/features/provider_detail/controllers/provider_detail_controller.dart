import 'package:flutter/foundation.dart';

import '../../../core/enums/provider_type.dart';
import '../../../core/utils/distance_calculator.dart';
import '../../../models/client_model.dart';
import '../../../models/service_model.dart';
import '../../../models/service_request_model.dart';
import '../../../services/client_service.dart';
import '../../../services/company_service.dart';
import '../../../services/request_service.dart';
import '../../../services/review_service.dart';
import '../../../services/service_service.dart';
import '../../../services/worker_service.dart';
import '../models/provider_detail_data.dart';
import '../models/provider_review_item.dart';

class ProviderDetailController extends ChangeNotifier {
  ProviderDetailController({
    required this.providerId,
    required this.providerType,
    required this.requestId,
    required WorkerService workerService,
    required CompanyService companyService,
    required ServiceService serviceService,
    required RequestService requestService,
    required ReviewService reviewService,
    required ClientService clientService,
  })  : _workerService = workerService,
        _companyService = companyService,
        _serviceService = serviceService,
        _requestService = requestService,
        _reviewService = reviewService,
        _clientService = clientService;

  final String providerId;
  final ProviderType providerType;
  final String requestId;
  final WorkerService _workerService;
  final CompanyService _companyService;
  final ServiceService _serviceService;
  final RequestService _requestService;
  final ReviewService _reviewService;
  final ClientService _clientService;

  ProviderDetailData? _provider;
  ServiceRequestModel? _request;
  List<ServiceModel> _services = const [];
  List<ProviderReviewItem> _reviews = const [];
  bool _isLoading = true;
  bool _isSubmitting = false;
  bool _isNotFound = false;
  String? _error;

  ProviderDetailData? get provider => _provider;
  ServiceRequestModel? get request => _request;
  List<ServiceModel> get services => List.unmodifiable(_services);
  List<ProviderReviewItem> get reviews => List.unmodifiable(_reviews);
  bool get isLoading => _isLoading;
  bool get isSubmitting => _isSubmitting;
  bool get isNotFound => _isNotFound;
  String? get error => _error;

  double? get distanceKm {
    final request = _request;
    final provider = _provider;
    if (request == null || provider == null) return null;
    return calculateDistanceKm(
      request.latitude,
      request.longitude,
      provider.latitude,
      provider.longitude,
    );
  }

  Future<void> load() async {
    _isLoading = true;
    _isNotFound = false;
    _error = null;
    notifyListeners();
    try {
      _request = await _requestService.getRequestById(requestId);
      _provider = await _loadProvider();
      if (_request == null || _provider == null) {
        _isNotFound = true;
        return;
      }

      final servicesFuture = _serviceService.getServices();
      final reviewsFuture = _reviewService.getReviewsByProvider(providerId);
      final clientsFuture = _clientService.getClients();
      final allServices = await servicesFuture;
      final providerReviews = await reviewsFuture;
      final clients = await clientsFuture;
      final clientNames = <String, String>{
        for (final ClientModel client in clients) client.id: client.fullName,
      };
      _services = List.unmodifiable(
        allServices.where(
          (service) => _provider!.serviceIds.contains(service.id),
        ),
      );
      _reviews = List.unmodifiable(
        providerReviews.take(3).map(
              (review) => ProviderReviewItem(
                review: review,
                clientName: clientNames[review.clientId] ?? 'Cliente FixGeo',
              ),
            ),
      );
    } catch (_) {
      _error = 'No pudimos cargar la información del prestador.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ServiceRequestModel?> selectProvider() async {
    if (_provider == null || _request == null || _isSubmitting) return null;
    _isSubmitting = true;
    _error = null;
    notifyListeners();
    try {
      _request = await _requestService.selectProvider(
        requestId: requestId,
        providerId: providerId,
        providerType: providerType,
      );
      return _request;
    } catch (_) {
      _error = 'No pudimos seleccionar este prestador. Intenta nuevamente.';
      return null;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  Future<ProviderDetailData?> _loadProvider() async {
    if (providerType == ProviderType.worker) {
      final worker = await _workerService.getWorkerById(providerId);
      return worker == null ? null : ProviderDetailData.fromWorker(worker);
    }
    final company = await _companyService.getCompanyById(providerId);
    return company == null ? null : ProviderDetailData.fromCompany(company);
  }
}
