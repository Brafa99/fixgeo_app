import 'package:image_picker/image_picker.dart';

enum CompanyImageSource { gallery, camera }

class CompanyImagePickerService {
  CompanyImagePickerService({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<String?> pick(CompanyImageSource source) async {
    final image = await _picker.pickImage(
      source: source == CompanyImageSource.gallery
          ? ImageSource.gallery
          : ImageSource.camera,
      imageQuality: 84,
      maxWidth: 1600,
    );
    return image?.path;
  }
}
