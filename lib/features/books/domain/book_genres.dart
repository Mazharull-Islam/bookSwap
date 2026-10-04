/// Splits a book's comma-joined genre text ("Fantasy, Adventure") into the
/// individual genres. Empty text gives an empty list.
List<String> bookGenreList(String genre) => genre.trim().isEmpty
    ? const []
    : genre.split(',').map((g) => g.trim()).where((g) => g.isNotEmpty).toList();
