import 'package:flutter/material.dart';
import '../../domain/entities/reading_entry.dart';
import '../../../../app/app_colors.dart';

String readingStatusLabel(ReadingStatus status) => switch (status) {
  ReadingStatus.planToRead => 'Plan to read',
  ReadingStatus.reading => 'Reading',
  ReadingStatus.read => 'Read',
};

Color readingStatusColor(ReadingStatus status) => switch (status) {
  ReadingStatus.planToRead => StatusFills.returned,
  ReadingStatus.reading => StatusFills.pending,
  ReadingStatus.read => StatusFills.accepted,
};
