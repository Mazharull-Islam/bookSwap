import 'package:bookswap_login/features/wanted_books/domain/entities/wanted_book.dart';
import 'package:bookswap_login/features/wanted_books/domain/repositories/wanted_book_repository.dart';

/// Records which wishlist entries get deleted. Reads come from the provider
/// overrides in test_app.dart, so the watch streams stay empty.
class FakeWantedBookRepository implements WantedBookRepository {
  final removed = <String>[];

  @override
  Future<void> remove(String id) async => removed.add(id);

  @override
  Stream<List<WantedBook>> watchMine(String userId) => const Stream.empty();

  @override
  Stream<List<WantedBook>> watchAll() => const Stream.empty();

  @override
  Future<WantedBook> add({
    required String userId,
    required String title,
    required String author,
    String? coverUrl,
    String? workKey,
  }) => throw UnimplementedError();
}
