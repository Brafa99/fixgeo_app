import 'package:flutter/foundation.dart';

import '../../../core/enums/service_request_status.dart';
import '../../../models/service_model.dart';
import '../../../models/service_request_model.dart';
import '../../../models/user_model.dart';
import '../../../services/request_service.dart';
import '../../../services/service_service.dart';

class ConfirmServiceRequestController extends ChangeNotifier {
  ConfirmServiceRequestController({
    required ServiceRequestModel request,
    required this.user,
    required ServiceService serviceService,
    required RequestService requestService,
    DateTime Function()? clock,
  })  : _request = request,
        _serviceService = serviceService,
        _requestService = requestService,
        _clock = clock ?? DateTime.now;

  ServiceRequestModel _request;
  final UserModel? user;
  final ServiceService _serviceService;
  final RequestService _requestService;
  final DateTime Function() _clock;

  ServiceModel? _service;
  bool _isLoading = true;
  bool _isSearching = false;
  String? _error;

  ServiceRequestModel get request => _request;
  ServiceModel? get service => _service;
  bool get isLoading => _isLoading;
  bool get isSearching => _isSearching;
  String? get error => _error;

  Future<void> initialize() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _service = await _serviceService.getServiceById(_request.serviceId);
      if (_service == null || !_service!.isActive) {
        _error = 'El servicio seleccionado ya no está disponible.';
      }
    } catch (_) {
      _error = 'No pudimos cargar el resumen de la solicitud.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ServiceRequestModel?> startProviderSearch() async {
    final currentService = _service;
    if (_isSearching || currentService == null) return null;

    _isSearching = true;
    _error = null;
    notifyListeners();
    try {
      _request = await _requestService.updateRequest(
        _request.copyWith(
          status: ServiceRequestStatus.searching,
          updatedAt: _clock().toUtc(),
        ),
      );
      return _request;
    } catch (_) {
      _error = 'No pudimos iniciar la búsqueda. Intenta nuevamente.';
      return null;
    } finally {
      _isSearching = false;
      notifyListeners();
    }
  }
}
