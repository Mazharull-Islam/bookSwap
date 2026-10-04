/// Where profile photos are uploaded. Neither value is a secret: uploads go to
/// an *unsigned* preset, so no API key or secret is ever in the app. Override
/// with --dart-define=CLOUDINARY_CLOUD_NAME / CLOUDINARY_UPLOAD_PRESET.
abstract final class CloudinaryConfig {
  static const cloudName = String.fromEnvironment(
    'CLOUDINARY_CLOUD_NAME',
    defaultValue: 'o9we0m6d',
  );
  static const uploadPreset = String.fromEnvironment(
    'CLOUDINARY_UPLOAD_PRESET',
    defaultValue: 'bookswap_avatars',
  );

  static bool get configured => cloudName.isNotEmpty && uploadPreset.isNotEmpty;
}
