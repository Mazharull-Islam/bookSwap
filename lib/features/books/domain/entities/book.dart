/// Marks "argument not passed" in [copyWith], so null can be passed on purpose.
const Object _keep = Object();

enum BookStatus { available, requested, lent, returned }

const bookGenreOptions = [
  'Fiction',
  'Mystery',
  'Fantasy',
  'Science fiction',
  'Romance',
  'History',
  'Biography',
  'Self-development',
  'Science & technology',
  'Academic',
  'Poetry',
  'Other',
];

const bookConditionOptions = ['New', 'Like new', 'Good', 'Fair', 'Worn'];

String? _requiredText(String? value, String label) =>
    value == null || value.trim().isEmpty ? 'Enter the book\'s $label.' : null;

class Book {
  const Book({
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
    this.workKey,
    this.status = BookStatus.available,
    this.updatedAtMs = 0,
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

  final String? workKey;

  final BookStatus status;

  /// Epoch milliseconds of the last local write. Set by the repository,
  /// not the UI — used for last-write-wins conflict resolution when
  /// syncing with Firestore (SRS §3.6).
  final int updatedAtMs;

  Book copyWith({
    String? id,
    String? ownerId,
    String? title,
    String? author,
    String? genre,
    String? condition,
    double? estimatedValue,
    String? description,
    Object? coverPhotoUrl = _keep,
    Object? isbn = _keep,
    Object? workKey = _keep,
    BookStatus? status,
    int? updatedAtMs,
  }) => Book(
    id: id ?? this.id,
    ownerId: ownerId ?? this.ownerId,
    title: title ?? this.title,
    author: author ?? this.author,
    genre: genre ?? this.genre,
    condition: condition ?? this.condition,
    estimatedValue: estimatedValue ?? this.estimatedValue,
    description: description ?? this.description,
    coverPhotoUrl: identical(coverPhotoUrl, _keep)
        ? this.coverPhotoUrl
        : coverPhotoUrl as String?,
    isbn: identical(isbn, _keep) ? this.isbn : isbn as String?,
    workKey: identical(workKey, _keep) ? this.workKey : workKey as String?,
    status: status ?? this.status,
    updatedAtMs: updatedAtMs ?? this.updatedAtMs,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Book &&
          id == other.id &&
          ownerId == other.ownerId &&
          title == other.title &&
          author == other.author &&
          genre == other.genre &&
          condition == other.condition &&
          estimatedValue == other.estimatedValue &&
          description == other.description &&
          coverPhotoUrl == other.coverPhotoUrl &&
          isbn == other.isbn &&
          workKey == other.workKey &&
          status == other.status &&
          updatedAtMs == other.updatedAtMs;

  @override
  int get hashCode => Object.hashAll([
    Book,
    id,
    ownerId,
    title,
    author,
    genre,
    condition,
    estimatedValue,
    description,
    coverPhotoUrl,
    isbn,
    workKey,
    status,
    updatedAtMs,
  ]);

  @override
  String toString() => 'Book(id: $id)';

  String? validate() {
    return _requiredText(title, 'title') ??
        _requiredText(author, 'author') ??
        _requiredText(genre, 'genre') ??
        _requiredText(condition, 'condition') ??
        (estimatedValue < 0 ? 'Estimated value can\'t be negative.' : null);
  }
}
