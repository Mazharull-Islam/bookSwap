import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Reads the minimal, member-readable slice of another user's identity —
/// just a display name, never contact details. See firestore.rules'
/// public_profiles collection for the enforcement side of this.
class PublicProfileService {
  PublicProfileService(this._firestore);
  final FirebaseFirestore _firestore;

  Future<String?> fetchDisplayName(String uid) async {
    try {
      final doc = await _firestore.collection('public_profiles').doc(uid).get();
      return doc.data()?['firstName'] as String?;
    } catch (_) {
      // A lookup failure shouldn't block showing the book itself.
      return null;
    }
  }
}

final publicProfileServiceProvider = Provider<PublicProfileService>(
  (ref) => PublicProfileService(FirebaseFirestore.instance),
);

/// Cached per-uid by Riverpod — repeated lookups for the same owner within
/// a session don't re-hit Firestore.
final displayNameProvider = FutureProvider.family<String?, String>(
  (ref, uid) => ref.watch(publicProfileServiceProvider).fetchDisplayName(uid),
);
