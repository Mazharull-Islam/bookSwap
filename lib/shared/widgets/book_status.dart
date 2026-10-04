import 'package:flutter/material.dart';
import '../../app/app_colors.dart';
import '../../features/books/domain/entities/book.dart';

/// How a book's availability reads and is coloured, wherever it's shown.
String bookStatusLabel(BookStatus status) => switch (status) {
  BookStatus.available => 'Available',
  BookStatus.requested => 'Requested',
  BookStatus.lent => 'Lent out',
  BookStatus.returned => 'Returned',
};

Color bookStatusColor(BookStatus status) => switch (status) {
  BookStatus.available => StatusFills.accepted,
  BookStatus.requested => StatusFills.pending,
  BookStatus.lent => StatusFills.lent,
  BookStatus.returned => StatusFills.returned,
};
