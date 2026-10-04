import '../cloudinary_config.dart';

/// Largest photo the app will upload. The picker already shrinks images, so
/// this is a backstop.
const maxPhotoBytes = 5 * 1024 * 1024;

String _prefix(String cloudName) =>
    'https://res.cloudinary.com/$cloudName/image/upload/';

/// True only for an image on this app's own Cloudinary account. Anything else
/// (including an empty "no photo" value) is not shown, so a profile can't be
/// made to display an arbitrary outside image. The Firestore rules enforce the
/// same prefix on write.
bool isOurPhotoUrl(
  String? url, {
  String cloudName = CloudinaryConfig.cloudName,
}) => url != null && url.startsWith(_prefix(cloudName));

/// A small, face-centred, well-compressed version of [url] for an avatar
/// [size] logical pixels across, or null when there is no usable photo.
/// Cloudinary does the resizing on delivery; the stored URL stays the original.
String? avatarUrl(
  String? url, {
  required double size,
  String cloudName = CloudinaryConfig.cloudName,
}) {
  if (!isOurPhotoUrl(url, cloudName: cloudName)) return null;
  // Twice the size for high-density screens, in steps so similar sizes share
  // one cached image.
  final px = ((size * 2 / 32).ceil() * 32).clamp(64, 480);
  final prefix = _prefix(cloudName);
  final rest = url!.substring(prefix.length);
  return '${prefix}c_fill,g_face,w_$px,h_$px,f_auto,q_auto/$rest';
}
