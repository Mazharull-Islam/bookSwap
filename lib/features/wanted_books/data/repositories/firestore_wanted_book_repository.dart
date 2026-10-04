import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/wanted_book.dart';
import '../../domain/repositories/wanted_book_repository.dart';

/// Live, cross-user data like requests and public profiles — deliberately
/// bypasses Hive so a wishlist add/remove is immediately visible to the
/// mutual-match check on other members' devices, not just after a sync.
class FirestoreWantedBookRepository implements WantedBookRepository {
  FirestoreWantedBookRepository(this._firestore);
  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _wanted =>
      _firestore.collection('wanted_books');

  WantedBook _decode(Map<String, dynamic> json) => WantedBook.fromJson(json);

  List<WantedBook> _sorted(List<WantedBook> books) =>
      books..sort((a, b) => b.addedAtMs.compareTo(a.addedAtMs));

  @override
  Stream<List<WantedBook>> watchMine(String userId) => _wanted
      .where('userId', isEqualTo: userId)
      .snapshots()
      .map((s) => _sorted(s.docs.map((d) => _decode(d.data())).toList()));

  @override
  Stream<List<WantedBook>> watchAll() => _wanted
      .snapshots()
      .map((s) => _sorted(s.docs.map((d) => _decode(d.data())).toList()));

  @override
  Future<WantedBook> add({
    required String userId,
    required String title,
    required String author,
    String? coverUrl,
    String? workKey,
  }) async {
    final matchKey = wantedBookMatchKey(
      workKey: workKey,
      title: title,
      author: author,
    );
    final existing = await _wanted
        .where('userId', isEqualTo: userId)
        .where('matchKey', isEqualTo: matchKey)
        .limit(1)
        .get();
    if (existing.docs.isNotEmpty) {
      throw const WantedBookValidationFailure('Already in your wishlist.');
    }
    final doc = _wanted.doc();
    final wanted = WantedBook(
      id: doc.id,
      userId: userId,
      title: title,
      author: author,
      coverUrl: coverUrl,
      workKey: workKey,
      matchKey: matchKey,
      addedAtMs: DateTime.now().millisecondsSinceEpoch,
    );
    await doc.set(wanted.toJson());
    return wanted;
  }

  @override
  Future<void> remove(String id) => _wanted.doc(id).delete();
}
