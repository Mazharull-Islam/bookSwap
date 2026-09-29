import 'package:flutter/material.dart';
import '../../domain/models/reading_entry.dart';

String readingStatusLabel(ReadingStatus status) => switch (status) {
  ReadingStatus.planToRead => 'Plan to read',
  ReadingStatus.reading => 'Reading',
  ReadingStatus.read => 'Read',
};

Color readingStatusColor(ReadingStatus status) => switch (status) {
  ReadingStatus.planToRead => const Color(0xFF7A7A7A),
  ReadingStatus.reading => const Color(0xFFB16C46),
  ReadingStatus.read => const Color(0xFF254E3B),
};
