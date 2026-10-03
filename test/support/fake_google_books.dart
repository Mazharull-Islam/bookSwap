import 'package:dio/dio.dart';
import 'package:bookswap_login/core/services/google_books_service.dart' as gb;

/// Answers findBest from memory; the default (no match) keeps every test off
/// the network.
class FakeGoogleBooks extends gb.GoogleBooksService {
  FakeGoogleBooks({this.match, this.fails = false}) : super(Dio());
  final gb.BookMetadata? match;
  final bool fails;
  int lookups = 0;

  @override
  Future<gb.BookMetadata?> findBest({
    required String title,
    String author = '',
    String? isbn,
  }) async {
    lookups++;
    if (fails) throw const gb.BookLookupFailure('offline');
    return match;
  }
}
