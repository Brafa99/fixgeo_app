import 'package:flutter/foundation.dart';

import '../models/company_registration_data.dart';
import '../services/company_image_picker_service.dart';
import '../services/company_registration_service.dart';

class CompanyRegistrationController extends ChangeNotifier {
  CompanyRegistrationController({
    CompanyRegistrationService? service,
    CompanyImagePickerService? imagePickerService,
  })  : _service = service ?? const LocalCompanyRegistrationService(),
        _imagePickerService = imagePickerService ?? CompanyImagePickerService();

  final CompanyRegistrationService _service;
  final CompanyImagePickerService _imagePickerService;

  CompanyRegistrationData _data = const CompanyRegistrationData();
  bool _isSubmitting = false;
  bool _isPickingLogo = false;

  CompanyRegistrationData get data => _data;
  bool get isSubmitting => _isSubmitting;
  bool get isPickingLogo => _isPickingLogo;

  void updateBusinessData({
    String? companyName,
    String? presentation,
  }) {
    _data = _data.copyWith(
      companyName: companyName,
      presentation: presentation,
    );
    notifyListeners();
  }

  void updateRepresentative({
    String? name,
    String? lastName,
    String? document,
    String? city,
  }) {
    _data = _data.copyWith(
      representativeName: name,
      representativeLastName: lastName,
      document: document,
      city: city,
    );
    notifyListeners();
  }

  void updateContact({
    String? phone,
    String? email,
    String? password,
    String? confirmPassword,
  }) {
    _data = _data.copyWith(
      phone: phone,
      email: email,
      password: password,
      confirmPassword: confirmPassword,
    );
    notifyListeners();
  }

  void toggleService(String serviceId) {
    final services = _data.services.toSet();
    if (!services.add(serviceId)) services.remove(serviceId);
    _data = _data.copyWith(services: services.toList(growable: false));
    notifyListeners();
  }

  void setAcceptedTerms(bool value) {
    _data = _data.copyWith(acceptedTerms: value);
    notifyListeners();
  }

  Future<void> pickLogo(CompanyImageSource source) async {
    if (_isPickingLogo) return;
    _isPickingLogo = true;
    notifyListeners();
    try {
      final path = await _imagePickerService.pick(source);
      if (path != null) _data = _data.copyWith(logoPath: path);
    } finally {
      _isPickingLogo = false;
      notifyListeners();
    }
  }

  void removeLogo() {
    _data = _data.copyWith(clearLogoPath: true);
    notifyListeners();
  }

  Future<void> submit() async {
    if (_isSubmitting) return;
    _isSubmitting = true;
    notifyListeners();
    try {
      final userId = await _service.createAuthUser(_data);
      final logoUrl = await _service.uploadCompanyLogo(
        userId,
        _data.logoPath,
      );
      final companyId = await _service.createCompany(
        _data,
        userId: userId,
        logoUrl: logoUrl,
      );
      await _service.associateServices(companyId, _data.services);
      _data = _data.copyWith(logoUrl: logoUrl);
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
