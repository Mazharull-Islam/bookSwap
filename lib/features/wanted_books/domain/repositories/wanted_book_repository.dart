import '../models/wanted_book.dart';

class WantedBookValidationFailure implements Exception {
  const WantedBookValidationFailure(this.message);
  final String message;
}

abstract interface class WantedBookRepository {
  /// My own wishlist.
  Stream<List<WantedBook>> watchMine(String userId);

  /// Every member's wishlist — needed client-side to detect mutual swaps,
  /// since there's no backend function to do that matching centrally.
  Stream<List<WantedBook>> watchAll();

  Future<WantedBook> add({
    required String userId,
    required String title,
    required String author,
    String? coverUrl,
    String? workKey,
  });

  Future<void> remove(String id);
}
