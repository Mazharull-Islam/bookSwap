import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/entities/public_profile.dart';

// The service hands out PublicProfile values, so its importers get the type too.
export '../../shared/entities/public_profile.dart';

/// How a [PublicProfile] is stored in the `public_profiles` document.
abstract final class PublicProfileDto {
  static PublicProfile parse(String uid, Map<String, dynamic>? data) =>
      PublicProfile(
        uid: uid,
        firstName: data?['firstName'] as String?,
        latitude: (data?['latitude'] as num?)?.toDouble(),
        longitude: (data?['longitude'] as num?)?.toDouble(),
        photoUrl: data?['photoUrl'] as String?,
      );
}

class PublicProfileService {
  PublicProfileService(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestore.collection('public_profiles');

  Future<String?> fetchDisplayName(String uid) async {
    try {
      final doc = await _collection.doc(uid).get();
      return doc.data()?['firstName'] as String?;
    } catch (_) {
      // A lookup failure shouldn't block showing the book itself.
      return null;
    }
  }

  /// Every member's public profile, live — needed to compute distance to
  /// Discovery listings client-side (SRS §3.1/§3.3), since there's no
  /// backend function to do that privately. See roundCoordinate() for the
  /// precision trim this relies on.
  Stream<Map<String, PublicProfile>> watchAll() => _collection.snapshots().map(
    (s) => {
      for (final doc in s.docs)
        doc.id: PublicProfileDto.parse(doc.id, doc.data()),
    },
  );

  /// Sets (or, with an empty string, clears) the member's photo.
  Future<void> updatePhoto(String uid, String url) =>
      _collection.doc(uid).set({'photoUrl': url}, SetOptions(merge: true));

  /// Merge-set rather than update so accounts that predate public_profiles
  /// (no doc yet) get one created instead of being rejected.
  Future<void> updateLocation(
    String uid,
    String firstName,
    double lat,
    double lng,
  ) => _collection.doc(uid).set({
    'firstName': firstName,
    'latitude': lat,
    'longitude': lng,
  }, SetOptions(merge: true));
}

final publicProfileServiceProvider = Provider<PublicProfileService>(
  (ref) => PublicProfileService(FirebaseFirestore.instance),
);

/// Cached per-uid by Riverpod — repeated lookups for the same owner within
/// a session don't re-hit Firestore.
final displayNameProvider = FutureProvider.family<String?, String>(
  (ref, uid) => ref.watch(publicProfileServiceProvider).fetchDisplayName(uid),
);

final allPublicProfilesProvider = StreamProvider<Map<String, PublicProfile>>(
  (ref) => ref.watch(publicProfileServiceProvider).watchAll(),
);
