import 'package:flutter/foundation.dart';

import '../models/register_client_data.dart';
import '../services/register_service.dart';
import 'register_validators.dart';

class RegisterController extends ChangeNotifier {
  RegisterController({RegisterService? service})
      : _service = service ?? const LocalRegisterService();

  final RegisterService _service;

  RegisterClientData _data = const RegisterClientData();
  bool _isSubmitting = false;

  RegisterClientData get data => _data;
  bool get isSubmitting => _isSubmitting;

  bool get canSubmit {
    return RegisterValidators.password(_data.password) == null &&
        _data.password == _data.confirmPassword &&
        _data.acceptedTerms;
  }

  void updatePersonalData({
    String? firstName,
    String? lastName,
    String? city,
  }) {
    _data = _data.copyWith(
      firstName: firstName,
      lastName: lastName,
      city: city,
    );
    notifyListeners();
  }

  void updateContactData({
    String? phone,
    String? countryCode,
    String? email,
  }) {
    _data = _data.copyWith(
      phone: phone,
      countryCode: countryCode,
      email: email,
    );
    notifyListeners();
  }

  void updateAccessData({
    String? password,
    String? confirmPassword,
    bool? acceptedTerms,
  }) {
    _data = _data.copyWith(
      password: password,
      confirmPassword: confirmPassword,
      acceptedTerms: acceptedTerms,
    );
    notifyListeners();
  }

  Future<void> submit() async {
    if (_isSubmitting || !canSubmit) return;
    _isSubmitting = true;
    notifyListeners();
    try {
      await _service.registerClient(_data);
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
