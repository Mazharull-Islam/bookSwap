/// The member-readable slice of another user's identity: a display name, an
/// optional photo and an optional, deliberately coarse (~1km) location. Never
/// contact details. See firestore.rules' public_profiles collection for the
/// enforcement side of this.
class PublicProfile {
  const PublicProfile({
    required this.uid,
    this.firstName,
    this.latitude,
    this.longitude,
    this.photoUrl,
  });

  final String uid;
  final String? firstName;
  final double? latitude;
  final double? longitude;

  /// A Cloudinary image URL, or null/empty when the member has no photo.
  final String? photoUrl;

  bool get hasLocation => latitude != null && longitude != null;
}
