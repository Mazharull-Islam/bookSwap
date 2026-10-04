import 'entities/reading_activity.dart';

class ReaderRanking {
  const ReaderRanking({
    required this.userId,
    required this.userName,
    required this.count,
  });
  final String userId;
  final String userName;
  final int count;
}

class AuthorRanking {
  const AuthorRanking({required this.author, required this.count});
  final String author;
  final int count;
}

List<ReaderRanking> topReaders(List<ReadingActivity> activity) {
  final counts = <String, int>{};
  final names = <String, String>{};
  for (final a in activity) {
    counts[a.userId] = (counts[a.userId] ?? 0) + 1;
    names[a.userId] = a.userName;
  }
  final ranked =
      counts.entries
          .map(
            (e) => ReaderRanking(
              userId: e.key,
              userName: names[e.key]!,
              count: e.value,
            ),
          )
          .toList()
        ..sort((a, b) => b.count.compareTo(a.count));
  return ranked;
}

List<AuthorRanking> topAuthors(List<ReadingActivity> activity) {
  final counts = <String, int>{};
  for (final a in activity) {
    final author = a.author.trim();
    if (author.isEmpty) continue;
    counts[author] = (counts[author] ?? 0) + 1;
  }
  final ranked =
      counts.entries
          .map((e) => AuthorRanking(author: e.key, count: e.value))
          .toList()
        ..sort((a, b) => b.count.compareTo(a.count));
  return ranked;
}
