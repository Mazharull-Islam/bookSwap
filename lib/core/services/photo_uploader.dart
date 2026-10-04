import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../cloudinary_config.dart';
import '../utils/photo_url.dart';

/// Something went wrong putting a photo online. [message] is fit to show.
class PhotoUploadFailure implements Exception {
  const PhotoUploadFailure(this.message);
  final String message;

  @override
  String toString() => message;
}

abstract interface class PhotoUploader {
  /// False when no Cloudinary account is configured.
  bool get available;

  /// Uploads [bytes] and returns the image's public https URL.
  Future<String> upload(Uint8List bytes, {required String filename});
}

/// Unsigned upload straight to Cloudinary: the preset (created in the
/// Cloudinary dashboard) decides what's allowed, so the app needs no secret
/// and no backend.
class CloudinaryPhotoUploader implements PhotoUploader {
  CloudinaryPhotoUploader(
    this._dio, {
    this.cloudName = CloudinaryConfig.cloudName,
    this.uploadPreset = CloudinaryConfig.uploadPreset,
  });

  final Dio _dio;
  final String cloudName;
  final String uploadPreset;

  @override
  bool get available => cloudName.isNotEmpty && uploadPreset.isNotEmpty;

  @override
  Future<String> upload(Uint8List bytes, {required String filename}) async {
    if (!available) {
      throw const PhotoUploadFailure('Photos are not set up yet.');
    }
    if (bytes.length > maxPhotoBytes) {
      throw const PhotoUploadFailure(
        'That photo is too large. Choose one under 5 MB.',
      );
    }
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        'https://api.cloudinary.com/v1_1/$cloudName/image/upload',
        data: FormData.fromMap({
          'upload_preset': uploadPreset,
          'file': MultipartFile.fromBytes(bytes, filename: filename),
        }),
      );
      final url = response.data?['secure_url'];
      if (url is! String || !isOurPhotoUrl(url, cloudName: cloudName)) {
        throw const PhotoUploadFailure(
          "The photo couldn't be saved. Try again.",
        );
      }
      return url;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status != null && status >= 400 && status < 500) {
        throw const PhotoUploadFailure(
          'That photo was not accepted. Try a JPG or PNG.',
        );
      }
      throw const PhotoUploadFailure(
        "Couldn't upload the photo. Check your connection and try again.",
      );
    }
  }
}

final photoUploaderProvider = Provider<PhotoUploader>(
  (ref) => CloudinaryPhotoUploader(
    Dio(
      BaseOptions(
        connectTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 60),
        receiveTimeout: const Duration(seconds: 30),
      ),
    ),
  ),
);
