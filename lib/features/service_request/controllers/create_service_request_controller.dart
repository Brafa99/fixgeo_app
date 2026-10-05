import 'package:flutter/foundation.dart';

import '../../../core/enums/service_request_status.dart';
import '../../../models/client_model.dart';
import '../../../models/service_model.dart';
import '../../../models/service_request_model.dart';
import '../../../models/user_model.dart';
import '../../../services/client_service.dart';
import '../../../services/request_service.dart';
import '../../../services/service_service.dart';
import '../services/service_request_image_picker.dart';

enum ServiceScheduleOption { asSoonAsPossible, chooseDate }

class CreateServiceRequestController extends ChangeNotifier {
  CreateServiceRequestController({
    required this.serviceId,
    required this.user,
    required ServiceService serviceService,
    required ClientService clientService,
    required RequestService requestService,
    required ServiceRequestImagePicker imagePicker,
    DateTime Function()? clock,
  })  : _serviceService = serviceService,
        _clientService = clientService,
        _requestService = requestService,
        _imagePicker = imagePicker,
        _clock = clock ?? DateTime.now;

  static const int descriptionMinLength = 10;
  static const int descriptionMaxLength = 500;
  static const int maxImages = 5;

  final String serviceId;
  final UserModel? user;
  final ServiceService _serviceService;
  final ClientService _clientService;
  final RequestService _requestService;
  final ServiceRequestImagePicker _imagePicker;
  final DateTime Function() _clock;

  ServiceModel? _service;
  String _description = '';
  String _address = '';
  double? _latitude;
  double? _longitude;
  List<String> _images = const [];
  ServiceScheduleOption _scheduleOption =
      ServiceScheduleOption.asSoonAsPossible;
  DateTime? _scheduledDate;
  bool _isLoading = true;
  bool _isPickingImages = false;
  bool _isSubmitting = false;
  String? _loadError;
  String? _actionError;
  ServiceRequestModel? _persistedRequest;

  ServiceModel? get service => _service;
  String get description => _description;
  String get address => _address;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  List<String> get images => List.unmodifiable(_images);
  ServiceScheduleOption get scheduleOption => _scheduleOption;
  DateTime? get scheduledDate => _scheduledDate;
  bool get isLoading => _isLoading;
  bool get isPickingImages => _isPickingImages;
  bool get isSubmitting => _isSubmitting;
  String? get loadError => _loadError;
  String? get actionError => _actionError;

  bool get hasValidService => _service?.isActive ?? false;

  bool get hasValidLocation =>
      _address.trim().isNotEmpty && _latitude != null && _longitude != null;

  bool get hasValidDate =>
      _scheduleOption == ServiceScheduleOption.asSoonAsPossible ||
      (_scheduledDate != null && !_isBeforeToday(_scheduledDate!));

  bool get canContinue =>
      !_isLoading &&
      !_isSubmitting &&
      user != null &&
      hasValidService &&
      validateDescription(_description) == null &&
      hasValidLocation &&
      hasValidDate;

  String get locationSummary {
    final parts = _address
        .split(',')
        .map((part) => part.trim())
        .where((part) => part.isNotEmpty)
        .toList();
    return parts.length >= 2 ? parts[parts.length - 2] : _address.trim();
  }

  String get dateSummary {
    if (_scheduleOption == ServiceScheduleOption.asSoonAsPossible) {
      return 'Lo antes posible';
    }
    final date = _scheduledDate;
    if (date == null) return 'Fecha pendiente';
    return '${_twoDigits(date.day)}/${_twoDigits(date.month)}/${date.year}';
  }

  Future<void> initialize() async {
    _isLoading = true;
    _loadError = null;
    notifyListeners();
    try {
      _service = await _serviceService.getServiceById(serviceId);
      final currentUser = user;
      ClientModel? client;
      if (currentUser is ClientModel) {
        client = currentUser;
      } else if (currentUser != null) {
        client = await _clientService.getClientById(currentUser.id);
      }
      _latitude = currentUser?.latitude ?? client?.latitude;
      _longitude = currentUser?.longitude ?? client?.longitude;
      _address = client?.address ?? '';
    } catch (_) {
      _loadError = 'No pudimos cargar los datos de la solicitud.';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String? validateDescription(String? value) {
    final description = value?.trim() ?? '';
    if (description.isEmpty) {
      return 'Describe brevemente el servicio que necesitas.';
    }
    if (description.length < descriptionMinLength) {
      return 'Escribe al menos $descriptionMinLength caracteres.';
    }
    if (description.length > descriptionMaxLength) {
      return 'La descripción no puede superar $descriptionMaxLength caracteres.';
    }
    return null;
  }

  void updateDescription(String value) {
    _description = value;
    _actionError = null;
    notifyListeners();
  }

  void updateLocation({
    required String address,
    double? latitude,
    double? longitude,
  }) {
    _address = address.trim();
    _latitude = latitude ?? _latitude;
    _longitude = longitude ?? _longitude;
    _actionError = null;
    notifyListeners();
  }

  void setScheduleOption(ServiceScheduleOption option) {
    _scheduleOption = option;
    if (option == ServiceScheduleOption.asSoonAsPossible) {
      _scheduledDate = null;
    }
    _actionError = null;
    notifyListeners();
  }

  void setScheduledDate(DateTime date) {
    _scheduledDate = DateTime(date.year, date.month, date.day);
    _scheduleOption = ServiceScheduleOption.chooseDate;
    _actionError = null;
    notifyListeners();
  }

  Future<void> addImages(ServiceRequestImageSource source) async {
    if (_isPickingImages || _images.length >= maxImages) return;
    _isPickingImages = true;
    _actionError = null;
    notifyListeners();
    try {
      final selected = await _imagePicker.pick(source);
      final availableSlots = maxImages - _images.length;
      final uniqueImages = selected
          .where((path) => path.trim().isNotEmpty && !_images.contains(path))
          .take(availableSlots);
      _images = List.unmodifiable([..._images, ...uniqueImages]);
    } catch (_) {
      _actionError = 'No pudimos agregar las fotos. Intenta nuevamente.';
    } finally {
      _isPickingImages = false;
      notifyListeners();
    }
  }

  void removeImage(String path) {
    _images = List.unmodifiable(_images.where((image) => image != path));
    notifyListeners();
  }

  Future<ServiceRequestModel?> submit() async {
    if (!canContinue) {
      _actionError = _validationMessage();
      notifyListeners();
      return null;
    }

    _isSubmitting = true;
    _actionError = null;
    notifyListeners();
    try {
      final timestamp = _clock().toUtc();
      final previousRequest = _persistedRequest;
      final request = ServiceRequestModel(
        id: previousRequest?.id ??
            'request_${user!.id}_${timestamp.microsecondsSinceEpoch}',
        clientId: user!.id,
        serviceId: serviceId,
        description: _description.trim(),
        latitude: _latitude!,
        longitude: _longitude!,
        address: _address.trim(),
        images: List.unmodifiable(_images),
        status: ServiceRequestStatus.pending,
        scheduledFor: _scheduleOption == ServiceScheduleOption.chooseDate
            ? _scheduledDate
            : null,
        createdAt: previousRequest?.createdAt ?? timestamp,
        updatedAt: timestamp,
      );
      final persistedRequest = previousRequest == null
          ? await _requestService.createRequest(request)
          : await _requestService.updateRequest(request);
      _persistedRequest = persistedRequest;
      return persistedRequest;
    } catch (_) {
      _actionError = 'No pudimos crear la solicitud. Intenta nuevamente.';
      return null;
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }

  String _validationMessage() {
    if (!hasValidService) return 'El servicio seleccionado no es válido.';
    if (user == null) return 'Inicia sesión para pedir un servicio.';
    final descriptionError = validateDescription(_description);
    if (descriptionError != null) return descriptionError;
    if (!hasValidLocation) return 'Selecciona una ubicación válida.';
    if (!hasValidDate) return 'Selecciona una fecha válida.';
    return 'Revisa los datos de la solicitud.';
  }

  bool _isBeforeToday(DateTime date) {
    final now = _clock();
    final today = DateTime(now.year, now.month, now.day);
    final comparableDate = DateTime(date.year, date.month, date.day);
    return comparableDate.isBefore(today);
  }

  static String _twoDigits(int value) => value.toString().padLeft(2, '0');
}
