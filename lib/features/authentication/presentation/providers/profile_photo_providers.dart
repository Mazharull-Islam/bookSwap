import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../app/providers/current_user_provider.dart';
import '../../../../core/services/photo_picker.dart';
import '../../../../core/services/photo_uploader.dart';
import '../../../../core/services/public_profile_service.dart';

/// The signed-in member's own photo URL, as stored in their public profile.
final myPhotoUrlProvider = Provider<String?>((ref) {
  final me = ref.watch(currentUserProvider).id;
  return ref.watch(
    allPublicProfilesProvider.select((p) => p.valueOrNull?[me]?.photoUrl),
  );
});

/// Choosing, uploading and saving (or removing) the member's photo.
class ProfilePhotoActions {
  ProfilePhotoActions({
    required this.picker,
    required this.uploader,
    required this.profiles,
    required this.userId,
  });

  final PhotoPicker picker;
  final PhotoUploader uploader;
  final PublicProfileService profiles;
  final String userId;

  bool get available => uploader.available;

  /// True when the photo was changed, false when the member backed out.
  /// Throws [PhotoUploadFailure] (with a message to show) if it fails; the
  /// existing photo is left alone in that case.
  Future<bool> change(PhotoSource source) async {
    final PickedPhoto? picked;
    try {
      picked = await picker.pick(source);
    } catch (_) {
      throw const PhotoUploadFailure(
        "Couldn't open your photos. Check that BookSwap is allowed to use "
        'the camera and photos, then try again.',
      );
    }
    if (picked == null) return false;
    final url = await uploader.upload(picked.bytes, filename: picked.name);
    await _save(url);
    return true;
  }

  /// Clears the photo. The uploaded image stays in Cloudinary (the app can't
  /// delete it without a secret) but is no longer shown anywhere.
  Future<void> remove() => _save('');

  Future<void> _save(String url) async {
    try {
      await profiles.updatePhoto(userId, url);
    } catch (_) {
      throw const PhotoUploadFailure("Couldn't save your photo. Try again.");
    }
  }
}

final profilePhotoActionsProvider = Provider<ProfilePhotoActions>(
  (ref) => ProfilePhotoActions(
    picker: ref.watch(photoPickerProvider),
    uploader: ref.watch(photoUploaderProvider),
    profiles: ref.watch(publicProfileServiceProvider),
    userId: ref.watch(currentUserProvider).id,
  ),
);
