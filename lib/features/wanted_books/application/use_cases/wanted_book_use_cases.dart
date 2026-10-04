import '../../domain/entities/wanted_book.dart';
import '../../domain/repositories/wanted_book_repository.dart';

class AddWantedBook {
  const AddWantedBook(this.repository);
  final WantedBookRepository repository;

  Future<WantedBook> call({
    required String userId,
    required String title,
    required String author,
    String? coverUrl,
    String? workKey,
  }) => repository.add(
    userId: userId,
    title: title,
    author: author,
    coverUrl: coverUrl,
    workKey: workKey,
  );
}

class RemoveWantedBook {
  const RemoveWantedBook(this.repository);
  final WantedBookRepository repository;

  Future<void> call(String id) => repository.remove(id);
}
