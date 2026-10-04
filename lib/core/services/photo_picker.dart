import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';

enum PhotoSource { camera, gallery }

class PickedPhoto {
  const PickedPhoto(this.bytes, this.name);
  final Uint8List bytes;
  final String name;
}

abstract interface class PhotoPicker {
  /// Null when the member backs out without choosing anything.
  Future<PickedPhoto?> pick(PhotoSource source);
}

class ImagePickerPhotoPicker implements PhotoPicker {
  final _picker = ImagePicker();

  @override
  Future<PickedPhoto?> pick(PhotoSource source) async {
    // Shrunk on the device, so uploads stay small and fast.
    final file = await _picker.pickImage(
      source: source == PhotoSource.camera
          ? ImageSource.camera
          : ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (file == null) return null;
    return PickedPhoto(await file.readAsBytes(), file.name);
  }
}

final photoPickerProvider = Provider<PhotoPicker>(
  (ref) => ImagePickerPhotoPicker(),
);
