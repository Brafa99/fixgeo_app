import 'package:flutter/foundation.dart';

import '../models/worker_registration_data.dart';
import '../services/worker_image_picker_service.dart';
import '../services/worker_registration_service.dart';

class WorkerRegistrationController extends ChangeNotifier {
  WorkerRegistrationController({
    WorkerRegistrationService? service,
    WorkerImagePickerService? imagePickerService,
  })  : _service = service ?? const LocalWorkerRegistrationService(),
        _imagePickerService = imagePickerService ?? WorkerImagePickerService();

  final WorkerRegistrationService _service;
  final WorkerImagePickerService _imagePickerService;

  WorkerRegistrationData _data = const WorkerRegistrationData();
  bool _isSubmitting = false;
  bool _isPickingImage = false;

  WorkerRegistrationData get data => _data;
  bool get isSubmitting => _isSubmitting;
  bool get isPickingImage => _isPickingImage;

  void updateBasicData({
    String? firstName,
    String? lastName,
    String? document,
    String? city,
  }) {
    _data = _data.copyWith(
      firstName: firstName,
      lastName: lastName,
      document: document,
      city: city,
    );
    notifyListeners();
  }

  void updatePresentation(String value) {
    _data = _data.copyWith(presentation: value);
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

  void toggleCategory(String categoryId) {
    final categories = _data.categories.toSet();
    if (!categories.add(categoryId)) categories.remove(categoryId);
    _data = _data.copyWith(categories: categories.toList(growable: false));
    notifyListeners();
  }

  void setAcceptedTerms(bool value) {
    _data = _data.copyWith(acceptedTerms: value);
    notifyListeners();
  }

  Future<void> pickImage(WorkerImageSource source) async {
    if (_isPickingImage) return;
    _isPickingImage = true;
    notifyListeners();
    try {
      final path = await _imagePickerService.pick(source);
      if (path != null) _data = _data.copyWith(imagePath: path);
    } finally {
      _isPickingImage = false;
      notifyListeners();
    }
  }

  void removeImage() {
    _data = _data.copyWith(clearImagePath: true);
    notifyListeners();
  }

  Future<void> submit() async {
    if (_isSubmitting) return;
    _isSubmitting = true;
    notifyListeners();
    try {
      final userId = await _service.createAuthUser(_data);
      final imageUrl = await _service.uploadProfileImage(
        userId,
        _data.imagePath,
      );
      final workerId = await _service.createWorkerProfile(
        _data,
        userId: userId,
        imageUrl: imageUrl,
      );
      await _service.associateServices(workerId, _data.categories);
      _data = _data.copyWith(imageUrl: imageUrl);
    } finally {
      _isSubmitting = false;
      notifyListeners();
    }
  }
}
