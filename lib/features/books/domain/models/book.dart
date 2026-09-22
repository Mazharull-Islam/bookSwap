enum BookStatus { available, requested, lent, returned }

String? _requiredText(String? value, String label) =>
    value == null || value.trim().isEmpty ? 'Enter the book\'s $label.' : null;

class Book {
  Book({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.author,
    required this.genre,
    required this.condition,
    required this.estimatedValue,
    this.description = '',
    this.coverPhotoUrl,
    this.isbn,
    this.status = BookStatus.available,
  });

  final String id;
  final String ownerId;
  final String title;
  final String author;
  final String genre;
  final String condition;
  final double estimatedValue;
  final String description;
  final String? coverPhotoUrl;
  final String? isbn;
  final BookStatus status;

  Book copyWith({
    String? title,
    String? author,
    String? genre,
    String? condition,
    double? estimatedValue,
    String? description,
    String? coverPhotoUrl,
    String? isbn,
    BookStatus? status,
  }) {
    return Book(
      id: id,
      ownerId: ownerId,
      title: title ?? this.title,
      author: author ?? this.author,
      genre: genre ?? this.genre,
      condition: condition ?? this.condition,
      estimatedValue: estimatedValue ?? this.estimatedValue,
      description: description ?? this.description,
      coverPhotoUrl: coverPhotoUrl ?? this.coverPhotoUrl,
      isbn: isbn ?? this.isbn,
      status: status ?? this.status,
    );
  }

  String? validate() {
    return _requiredText(title, 'title') ??
        _requiredText(author, 'author') ??
        _requiredText(genre, 'genre') ??
        _requiredText(condition, 'condition') ??
        (estimatedValue < 0 ? 'Estimated value can\'t be negative.' : null);
  }
}
