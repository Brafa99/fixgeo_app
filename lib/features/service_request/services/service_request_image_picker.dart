import 'package:image_picker/image_picker.dart';

enum ServiceRequestImageSource { gallery, camera }

abstract interface class ServiceRequestImagePicker {
  Future<List<String>> pick(ServiceRequestImageSource source);
}

class LocalServiceRequestImagePicker implements ServiceRequestImagePicker {
  LocalServiceRequestImagePicker({ImagePicker? picker})
      : _picker = picker ?? ImagePicker();

  final ImagePicker _picker;

  @override
  Future<List<String>> pick(ServiceRequestImageSource source) async {
    if (source == ServiceRequestImageSource.camera) {
      final image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 84,
        maxWidth: 1600,
      );
      return image == null ? const [] : [image.path];
    }

    final images = await _picker.pickMultiImage(
      imageQuality: 84,
      maxWidth: 1600,
    );
    return images.map((image) => image.path).toList(growable: false);
  }
}
