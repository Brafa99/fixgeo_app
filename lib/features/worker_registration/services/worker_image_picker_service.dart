import 'package:image_picker/image_picker.dart';

enum WorkerImageSource { gallery, camera }

class WorkerImagePickerService {
  WorkerImagePickerService({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  Future<String?> pick(WorkerImageSource source) async {
    final image = await _picker.pickImage(
      source: source == WorkerImageSource.gallery
          ? ImageSource.gallery
          : ImageSource.camera,
      imageQuality: 84,
      maxWidth: 1600,
    );
    return image?.path;
  }
}
