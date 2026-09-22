import 'package:freezed_annotation/freezed_annotation.dart';

part 'book.freezed.dart';
part 'book.g.dart';

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

@freezed
abstract class Book with _$Book {
  const Book._();

  const factory Book({
    required String id,
    required String ownerId,
    required String title,
    required String author,
    required String genre,
    required String condition,
    required double estimatedValue,
    @Default('') String description,
    String? coverPhotoUrl,
    String? isbn,
    @Default(BookStatus.available) BookStatus status,
  }) = _Book;

  factory Book.fromJson(Map<String, dynamic> json) => _$BookFromJson(json);

  String? validate() {
    return _requiredText(title, 'title') ??
        _requiredText(author, 'author') ??
        _requiredText(genre, 'genre') ??
        _requiredText(condition, 'condition') ??
        (estimatedValue < 0 ? 'Estimated value can\'t be negative.' : null);
  }
}
